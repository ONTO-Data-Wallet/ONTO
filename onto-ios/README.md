# onto-ios
### 开发切换至dev分支
```bash
cd ~/OnChain
git checkout dev
pod install //下载第三方库
```
### 开发时注意事项
<<<<<<< HEAD
1. Viewcontroller全部继承BaseViewcontroller，VC尽量不要使用xib创建，自定义view随便
2. 公共的自定义View写在Onchain/Common/目录下
3. 网络请求的接口写在OnChain/Api.h文件中，具体方法请看CCRequest.h
4. 一些宏定义或者配置项写入OnChain/Config/Config.h文件中
5. 自定义的工具类写在OnChain/Utils中
6. 切换rootVC请参考ViewController.m文件的实现

=======
 1. Viewcontroller全部继承BaseViewcontroller，VC尽量不要使用xib创建，自定义view随便
 2. 公共的自定义View写在Onchain/Common/目录下
 3. 网络请求的接口写在OnChain/Api.h文件中，具体方法请看CCRequest.h
 4. 一些宏定义或者配置项写入OnChain/Config/Config.h文件中
 5. 自定义的工具类写在OnChain/Utils中
 6. 切换rootVC请参考ViewController.m文件的实现
>>>>>>> origin

