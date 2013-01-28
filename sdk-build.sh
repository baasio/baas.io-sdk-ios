\rm -R ./baas.io.framework
xcodebuild -target baas.io

mv build/Release-iphoneuniversal/baas.io.framework/ .
rm -R ./build
