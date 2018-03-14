# Uncomment this line to define a global platform for your project
 platform :ios, '9.0'
# Uncomment this line if you're using Swift
# use_frameworks!

def shared_pods
    pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'
    pod 'AFNetworking', '~> 2.0'
    pod 'AFJSONRPCClient'
    pod 'SVProgressHUD'
    pod 'MTBBarcodeScanner', '~> 2.0.3'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'MWFeedParser'
    
#    target 'qtum walletTests' do
#        inherit! :search_paths
#        pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'
#    end
end

target 'htmlcoin wallet prod foundation' do
    shared_pods
end

target 'htmlcoin wallet prod' do
    shared_pods
end

target 'htmlcoin wallet testnet' do
    shared_pods
end

target 'htmlcoin wallet staging' do
    shared_pods
end

#target 'QTUM Watch Extension' do
#    pod 'NKWatchActivityIndicator'
#end

