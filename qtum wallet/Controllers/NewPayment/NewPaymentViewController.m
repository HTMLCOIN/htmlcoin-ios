//
//  NewPaymentViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "NewPaymentViewController.h"
#import "TransactionManager.h"
#import "QRCodeViewController.h"
#import "TextFieldWithLine.h"
#import "TokenListViewController.h"
#import "ChoseTokenPaymentViewController.h"
#import "InformationPopUpViewController.h"
#import "ErrorPopUpViewController.h"
#import "SecurityPopupViewController.h"
#import "ConfirmPopUpViewController.h"
#import "NSNumber+Comparison.h"


@interface NewPaymentViewController () <UITextFieldDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *tokenTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *feeTextField;

@property (weak, nonatomic) IBOutlet UIButton *tokenButton;
@property (weak, nonatomic) IBOutlet UIImageView *tokenDisclousureImage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UISlider *feeSlider;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *residueValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedBalance;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withoutTokensConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *minFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxFeeLabel;

// Gas price and gas limit
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIView *gasValuesContainer;
@property (weak, nonatomic) IBOutlet UIView *gasSlidersContainer;
@property (weak, nonatomic) IBOutlet UILabel *gasPriceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLimitValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *gasPriceMinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasPriceMaxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLimitMinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLimitMaxValueLabel;

@property (weak, nonatomic) IBOutlet UISlider *gasPriceSlider;
@property (weak, nonatomic) IBOutlet UISlider *gasLimitSlider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstratinForEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForGasSlidersContainer;

@property (nonatomic) long gasPriceStep;
@property (nonatomic) long gasLimitStep;
@property (nonatomic) long gasPriceMin;
@property (nonatomic) long gasLimitMin;

// Properties

@property (strong, nonatomic) NSString* adress;
@property (strong, nonatomic) NSString* amount;
@property (strong, nonatomic) QTUMBigNumber* FEE;
@property (strong, nonatomic) QTUMBigNumber* gasPrice;
@property (strong, nonatomic) QTUMBigNumber* gasLimit;
@property (strong, nonatomic) QTUMBigNumber* minFee;
@property (strong, nonatomic) QTUMBigNumber* maxFee;

@property (strong,nonatomic) NSNumberFormatter* localeFormatter;

@property (nonatomic) CGFloat standartTopOffsetForSendButton;

@property (nonatomic) BOOL needUpdateTexfFields;
@property (nonatomic) BOOL isTokenChoosen;
@property (nonatomic) NSString* tokenNameString;
@property (nonatomic) BOOL needUpdateTokenTexfFields;

@property (nonatomic, copy) void (^afterCheckingBlock)(void);

- (IBAction)makePaymentButtonWasPressed:(id)sender;

@end

static NSInteger withTokenOffset = 100;
static NSInteger withoutTokenOffset = 40;

static NSInteger heightGasSlidersContainerClose = 0;
static NSInteger heightGasSlidersContainerOpen = 150;
static NSInteger closeTopForEditButton = 0;
static NSInteger openTopForEditButton = 15;
static NSInteger showedGasTopForSend = 30;
static NSInteger hidedGasTopForSend = -40;

@implementation NewPaymentViewController

@synthesize delegate;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    self.sendButtomBottomOffset = 27;
    self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", @"");
    
    [self configFee];
    [self configGasPrice];
    [self configGasLimit];
    
    [self.amountTextField setEnablePast:NO];
    
    [self.amountTextField addTarget:self action:@selector(updateSendButton) forControlEvents:UIControlEventEditingChanged];
    [self.addressTextField addTarget:self action:@selector(updateSendButton) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateTextFields];
    [self.delegate didViewLoad];
    [self updateScrollsConstraints];
    [self showOrHideGas:YES];
    //[self updateFeeInputs];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self updateSendButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.view endEditing:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

-(void)configFee {
    
    [self.feeTextField setEnablePast:NO];
    self.feeSlider.minimumValue = 0.1f;
    self.feeSlider.maximumValue = 0.2f;
    self.feeSlider.value = 0.1;
    self.FEE = [QTUMBigNumber decimalWithString:@"0.1"];
    self.feeTextField.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[self.FEE decimalNumber]]];
}

-(void)configGasPrice {
    self.gasPriceSlider.minimumValue = 40;
    self.gasPriceSlider.maximumValue = 100;
    self.gasPriceSlider.value = 40;
    self.gasPrice = [QTUMBigNumber decimalWithString:@"40"];
    self.gasPriceValueLabel.text = @"40";
    self.gasPriceMinValueLabel.text = @"40";
    self.gasPriceMaxValueLabel.text = @"100";
}

-(void)configGasLimit {
    self.gasLimitSlider.minimumValue = 400000000;
    self.gasLimitSlider.maximumValue = 1000000000;
    self.gasLimitSlider.value = 400000000;
    self.gasLimit = [QTUMBigNumber decimalWithString:@"400000000"];
    self.gasLimitValueLabel.text = @"400000000";
    self.gasLimitMinValueLabel.text = @"400000000";
    self.gasLimitMaxValueLabel.text = @"1000000000";
}

#pragma mark - Custom Accessors

-(NSNumberFormatter *)localeFormatter {
    
    if (!_localeFormatter) {
        _localeFormatter = [NSNumberFormatter new];
        _localeFormatter.locale = [NSLocale currentLocale];
        _localeFormatter.roundingMode = NSNumberFormatterRoundDown;
        _localeFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _localeFormatter.maximumFractionDigits = 8;
    }
    return _localeFormatter;
}

#pragma mark - Private


-(void)updateFeeInputs {
    self.feeSlider.hidden = self.isTokenChoosen;
    self.feeTextField.hidden = self.isTokenChoosen;
    self.maxFeeLabel.hidden = self.isTokenChoosen;
    self.minFeeLabel.hidden = self.isTokenChoosen;
}

- (void)updateTextFields {
    
    if (self.needUpdateTexfFields && self.addressTextField && self.amountTextField) {
        self.addressTextField.text = self.adress;
        self.amountTextField.text = self.amount;
        self.needUpdateTexfFields = NO;
    }
    
    if (self.needUpdateTokenTexfFields && self.isTokenChoosen && self.tokenTextField) {
        self.tokenTextField.text = self.tokenNameString;
        self.tokenNameString = nil;
        self.needUpdateTokenTexfFields = NO;
    }
}

-(void)updateSendButton {
    
    BOOL isFilled = [self isTextFieldsFilled];
    
    self.sendButton.enabled = isFilled;
    self.sendButton.alpha = isFilled ? 1 : 0.5f;
}

-(void)normalizeFee {
    
    QTUMBigNumber *feeValue = [QTUMBigNumber decimalWithString:self.feeTextField.text];
    
    if ([feeValue isGreaterThan:self.maxFee] ) {
        self.feeTextField.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[self.maxFee decimalNumber]]];
        self.FEE = self.maxFee;
    } else if ([feeValue isLessThan:self.minFee]) {
        self.feeTextField.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[self.minFee decimalNumber]]];
        self.FEE = self.minFee;
    } else {
        self.FEE = feeValue;
    }
}

-(BOOL)isTextFieldsFilled {
    
    BOOL isFilled = YES;
    for (TextFieldWithLine *textField in self.scrollView.subviews) {
        if ([textField isKindOfClass:[TextFieldWithLine class]] && textField.text.length == 0) {
            isFilled = NO;
        }
    }
    return isFilled;
}

- (void)updateScrollsConstraints {
    self.standartTopOffsetForSendButton = self.sendButtonTopConstraint.constant;
    [self.view layoutIfNeeded];
}

- (void)showOrHideGas:(BOOL)willAppear {
    BOOL hide = !self.isTokenChoosen;
    
    self.gasValuesContainer.hidden =
    self.gasSlidersContainer.hidden =
    self.editButton.hidden = hide;
    
    if (willAppear) {
        self.heightForGasSlidersContainer.constant = heightGasSlidersContainerClose;
        self.topConstratinForEdit.constant = closeTopForEditButton;
        [self.editButton setTitle:NSLocalizedString(@"EDIT", nil) forState:UIControlStateNormal];
    }
    self.sendButtonTopConstraint.constant = hide ? hidedGasTopForSend : showedGasTopForSend;
}

#pragma mark - NewPaymentOutput

-(void)updateControlsWithTokensExist:(BOOL) isExist
                   choosenTokenExist:(BOOL) choosenExist
                       walletBalance:(QTUMBigNumber*) walletBalance
              andUnconfimrmedBalance:(QTUMBigNumber*) walletUnconfirmedBalance {
    
    //updating constraints and activity info
    self.residueValueLabel.text = [NSString stringWithFormat:@"%@", [walletBalance.decimalNumber roundedNumberWithScale:8]];
    self.unconfirmedBalance.text = [NSString stringWithFormat:@"%@", [walletUnconfirmedBalance.decimalNumber roundedNumberWithScale:8]];

    BOOL isTokensExists = isExist;
    self.tokenTextField.hidden =
    self.tokenButton.hidden =
    self.tokenDisclousureImage.hidden = !isTokensExists;
    self.withoutTokensConstraint.constant = isTokensExists ? withTokenOffset : withoutTokenOffset;
    self.tokenDisclousureImage.tintColor = customBlueColor();
    
    if (!choosenExist) {
        self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", nil);
        self.isTokenChoosen = NO;
        self.needUpdateTokenTexfFields = NO;
        self.tokenNameString = nil;
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self updateScrollsConstraints];
    [self showOrHideGas:NO];
}

- (void)showLoaderPopUp {
    [[PopUpsManager sharedInstance] showLoaderPopUp];
}

- (void)showCompletedPopUp {
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForSend] presenter:nil completion:nil];
}

- (void)showErrorPopUp:(NSString *)message {
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    if (message) {
        content.messageString = message;
        content.titleString = NSLocalizedString(@"Failed", nil);
    }
    
    ErrorPopUpViewController *popUp = [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
    [popUp setOnlyCancelButton];
}

- (void)hideLoaderPopUp {
    [[PopUpsManager sharedInstance] dismissLoader];
}

- (void)showConfirmChangesPopUp {
    PopUpContent *content = [PopUpContentGenerator contentForConfirmChangesInSend];
    [[PopUpsManager sharedInstance] showConfirmPopUp:self withContent:content presenter:nil completion:nil];
}

- (void)clearFields {
    
    self.addressTextField.text = @"";
    self.amountTextField.text = @"";
    self.amount = nil;
    self.adress = nil;
    
    [self updateSendButton];
}

- (void)updateContentWithContract:(Contract*) contract {
    
    if (self.tokenTextField) {
        self.tokenTextField.text = contract ? contract.localName : NSLocalizedString(@"QTUM (Default)", @"");
        self.needUpdateTokenTexfFields = NO;
        self.tokenNameString = nil;
    } else {
        self.needUpdateTokenTexfFields = YES;
        self.tokenNameString = contract ? contract.localName : NSLocalizedString(@"QTUM (Default)", @"");
    }
    
    self.isTokenChoosen = contract ? YES : NO;
}

- (void)setMinFee:(QTUMBigNumber*) minFee andMaxFee:(QTUMBigNumber*) maxFee {
    
    self.feeSlider.maximumValue = [maxFee decimalNumber].floatValue;
    self.feeSlider.minimumValue = [minFee decimalNumber].floatValue;
    self.feeSlider.value = 0.1f;
    self.FEE = [QTUMBigNumber decimalWithString:@"0.1"];
    
    self.minFeeLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[minFee decimalNumber]]];
    self.maxFeeLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[maxFee decimalNumber]]];
    
    self.maxFee = maxFee;
    self.minFee = minFee;
}

- (void)setMinGasPrice:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max step:(long)step {
    
    long count = ([max integerValue] - [min integerValue]) / step;
    self.gasPriceSlider.maximumValue = count;
    self.gasPriceSlider.minimumValue = 0;
    self.gasPriceSlider.value = 0;
    
    self.gasPriceMin = [min integerValue];
    self.gasPriceStep = step;
    
    self.gasPrice = [QTUMBigNumber decimalWithString:min.stringValue];

    self.gasPriceValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[min decimalNumber]]];
    self.gasPriceMinValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[min decimalNumber]]];
    self.gasPriceMaxValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[max decimalNumber]]];
}

- (void)setMinGasLimit:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max standart:(QTUMBigNumber *)standart step:(long)step; {
    
    long count = ([max integerValue] - [min integerValue]) / step;
    long standartLong = ([standart integerValue] - [min integerValue]) / step;
    
    self.gasLimitSlider.maximumValue = count;
    self.gasLimitSlider.minimumValue = 0;
    self.gasLimitSlider.value = standartLong;
    
    self.gasLimitMin = [min integerValue];
    self.gasLimitStep = step;
    
    self.gasLimit = [QTUMBigNumber decimalWithString:standart.stringValue];
    
    self.gasLimitValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[standart decimalNumber]]];
    self.gasLimitMinValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[min decimalNumber]]];
    self.gasLimitMaxValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[max decimalNumber]]];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    if ([sender isKindOfClass:[InformationPopUpViewController class]]) {
        [self clearFields];
    }
    
    if ([sender isKindOfClass:[ConfirmPopUpViewController class]]) {
        [self.delegate changeToStandartOperation];
        if (self.afterCheckingBlock) {
            self.afterCheckingBlock();
            self.afterCheckingBlock = nil;
        }
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

#pragma mark - iMessage

- (void)setSendInfoItem:(SendInfoItem *)item {
    
    if (item.qtumAddressKey) {
        self.adress = item.qtumAddressKey.address.string;
    } else {
        self.adress = item.qtumAddress;
    }
    
    if (item.amountString && ![item.amountString isEqualToString:@""]) {
        QTUMBigNumber* amount = [QTUMBigNumber decimalWithString:item.amountString];
        self.amount =  [self.localeFormatter stringFromNumber:[amount decimalNumber]];
    }
    
    self.needUpdateTexfFields = YES;
    
    [self updateTextFields];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amountTextField) {
        if ([string isEqualToString:@","] || [string isEqualToString:@"."]) {
            return ![textField.text containsString:string] && !(textField.text.length == 0);
        }
    } else if (textField == self.feeTextField) {
        if ([string isEqualToString:@","] || [string isEqualToString:@"."]) {
            
            return ![textField.text containsString:string] && !(textField.text.length == 0);
            
        } else {
            
            QTUMBigNumber *feeValue = [QTUMBigNumber decimalWithString:textField.text];
            [self.feeSlider setValue:[feeValue decimalNumber].floatValue animated:YES];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.addressTextField && [self.delegate needCheckForChanges]) {
        [self showConfirmChangesPopUp];
        __weak typeof(self) weakSelf = self;
        self.afterCheckingBlock = ^{
            [weakSelf.addressTextField becomeFirstResponder];
        };
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.feeTextField) {
        [self normalizeFee];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)addDoneButtonToAmountTextField {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    toolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneItem];
    [toolbar sizeToFit];
    
    self.amountTextField.inputAccessoryView = toolbar;
}

- (void)done:(id)sender {
    [self.amountTextField resignFirstResponder];
}

#pragma mark - Action

- (IBAction)makePaymentButtonWasPressed:(id)sender {
    
    QTUMBigNumber* amount = [QTUMBigNumber decimalWithString:self.amountTextField.text];

    NSString *address = self.addressTextField.text;
    
    [self normalizeFee];

    [self.delegate didPresseSendActionWithAddress:address andAmount:amount fee:self.FEE gasPrice:self.gasPrice gasLimit:self.gasLimit];
}

- (IBAction)didChangeFeeSlider:(UISlider *) slider {
    
    NSDecimalNumber* sliderValue = (NSDecimalNumber*)[[[NSDecimalNumber alloc] initWithFloat:slider.value] roundedNumberWithScale:8];
    self.FEE = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
    
    self.feeTextField.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[self.FEE decimalNumber]]];
}

- (IBAction)didChangeGasPriceSlider:(UISlider *)slider {
    
    unsigned long value = self.gasPriceMin + (NSInteger)slider.value * self.gasPriceStep;
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
    self.gasPrice = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
    self.gasPriceValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[self.gasPrice decimalNumber]]];
}

- (IBAction)didChangeGasLimitSlider:(UISlider *)slider {
    
    unsigned long value = self.gasLimitMin + (NSInteger)slider.value * self.gasLimitStep;
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
    self.gasLimit = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
    self.gasLimitValueLabel.text = [NSString stringWithFormat:@"%@", [self.localeFormatter stringFromNumber:[self.gasLimit decimalNumber]]];
}

- (IBAction)actionVoidTap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)didPressedChoseTokensAction:(id)sender {
    
    if ([self.delegate needCheckForChanges]) {
        [self showConfirmChangesPopUp];
        __weak typeof(self) wealSelf = self;
        self.afterCheckingBlock = ^{
            [wealSelf.delegate didPresseChooseToken];
        };
        return;
    }
    
    [self.delegate didPresseChooseToken];
}

- (IBAction)didPressedScanQRCode:(id)sender {
    [self.delegate didPresseQRCodeScaner];
}

- (IBAction)actionEditPressed:(id)sender {
    CGFloat changeOffset;
    if (self.heightForGasSlidersContainer.constant == heightGasSlidersContainerOpen) {
        self.heightForGasSlidersContainer.constant = heightGasSlidersContainerClose;
        self.topConstratinForEdit.constant = closeTopForEditButton;
        
        changeOffset = - heightGasSlidersContainerClose - closeTopForEditButton;
        
        [self.editButton setTitle:NSLocalizedString(@"EDIT", nil) forState:UIControlStateNormal];
    } else {
        self.heightForGasSlidersContainer.constant = heightGasSlidersContainerOpen;
        self.topConstratinForEdit.constant = openTopForEditButton;
        
        changeOffset = heightGasSlidersContainerOpen + openTopForEditButton;
        
        [self.editButton setTitle:NSLocalizedString(@"CLOSE", nil) forState:UIControlStateNormal];
    }
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentOffset:CGPointMake(contentOffset.x, contentOffset.y + changeOffset) animated:NO];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender {
    [self.view layoutIfNeeded];
}

-(void)keyboardDidShow:(NSNotification *)sender {
    UITextField* highlightedTextField;
    
    if ([self.amountTextField isFirstResponder]) {
        highlightedTextField = self.amountTextField;
    } else if ([self.feeTextField isFirstResponder]){
        highlightedTextField = self.feeTextField;
    } else {
        return;
    }
    
    NSDictionary *info = [sender userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = kbSize.height - 50.0f;
    CGFloat topOfKeyboard = self.scrollView.frame.size.height - kbHeight;
    
    CGFloat offset = highlightedTextField.frame.origin.y - topOfKeyboard;
    
    if (offset > 0) {
        CGPoint bottomOffset = CGPointMake(0, offset + 20);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)sender{
    [self.view layoutIfNeeded];
}


@end
