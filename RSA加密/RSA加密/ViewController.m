//
//  ViewController.m
//  RSA加密
//
//  Created by macbook on 2020/1/14.
//  Copyright © 2020 常用测试demo. All rights reserved.
//
#warning 本文根据简书作者”jianshu_wl“的博客（https://www.jianshu.com/p/74a796ec5038）而做的记录，感谢原作者

#import "ViewController.h"
#import "RSAEncryptor.h"

@interface ViewController ()
/*
 生成环境是在mac系统下，使用openssl进行生成，首先打开终端，按下面这些步骤依次来做：
 
 1. 生成模长为1024bit的私钥文件private_key.pem
 
 openssl genrsa -out private_key.pem 1024
 2. 生成证书请求文件rsaCertReq.csr
 
 openssl req -new -key private_key.pem -out rsaCerReq.csr
 注意：这一步会提示输入国家、省份、mail等信息，可以根据实际情况填写，或者全部不用填写，直接全部敲回车.
 
 3. 生成证书rsaCert.crt，并设置有效时间为1年
 
 openssl x509 -req -days 3650 -in rsaCerReq.csr -signkey private_key.pem -out rsaCert.crt
 4. 生成供iOS使用的公钥文件public_key.der
 
 openssl x509 -outform der -in rsaCert.crt -out public_key.der
 5. 生成供iOS使用的私钥文件private_key.p12
 
 openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
 注意：这一步会提示给私钥文件设置密码，直接输入想要设置密码即可，然后敲回车，然后再验证刚才设置的密码，再次输入密码，然后敲回车，完毕！
 在解密时，private_key.p12文件需要和这里设置的密码配合使用，因此需要牢记此密码.
 
 6. 生成供Java使用的公钥rsa_public_key.pem
 
 openssl rsa -in private_key.pem -out rsa_public_key.pem -pubout
 7. 生成供Java使用的私钥pkcs8_private_key.pem
 
 openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt
 全部执行成功后，会生成如下文件，其中public_key.der和private_key.p12就是iOS需要用到的文件
 
 作者：jianshu_wl
 链接：https://www.jianshu.com/p/74a796ec5038
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test01];
    
    [self test02];
    
}
- (void)test01 {
    //原始数据
    NSString *originalString = @"这是一段将要使用'.der'文件加密的字符串!";
    
    //使用.der和.p12中的公钥私钥加密解密
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    NSString *encryptStr = [RSAEncryptor encryptString:originalString publicKeyWithContentsOfFile:public_key_path];
    NSLog(@"加密前:%@", originalString);
    NSLog(@"加密后:%@", encryptStr);
    NSLog(@"解密后:%@", [RSAEncryptor decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:@"1234"]);
}
- (void)test02 {
    //原始数据
    NSString *originalString = @"这是一段将要使用'秘钥字符串'进行加密的字符串!";
    
    //使用字符串格式的公钥私钥加密解密
    /*
     http://web.chacuo.net/netrsakeypair
     生成密钥对RSA
     */
    NSString *encryptStr = [RSAEncryptor encryptString:originalString publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDcpY+GbRnz0HOwMTFaMT0CMDdoiF1gUjbMOpXqMo4/jOvfUrrI1PwYHPxpUV7+fT3NiHcWMTTQm9IyWq1rDTuO483U5QyKprm9A3ZvoYzJjdQKlrvrzrmqhmPt3B+ylYW17FB89NvDEWM4G5CeXGJGrGSDLd0FLsRau+7YQZR2xQIDAQAB"];
    
    NSLog(@"加密前:%@", originalString);
    NSLog(@"加密后:%@", encryptStr);
    NSLog(@"解密后:%@", [RSAEncryptor decryptString:encryptStr privateKey:@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANylj4ZtGfPQc7AxMVoxPQIwN2iIXWBSNsw6leoyjj+M699SusjU/Bgc/GlRXv59Pc2IdxYxNNCb0jJarWsNO47jzdTlDIqmub0Ddm+hjMmN1AqWu+vOuaqGY+3cH7KVhbXsUHz028MRYzgbkJ5cYkasZIMt3QUuxFq77thBlHbFAgMBAAECgYA5WkOLUpKbYIShuLe2VPQhvHy6jC+RWO1repL7NDbrZ+rruqpYh5wbfHVTvtXtWoqVATLLLvEmhEpH0nAfUmo3R4psUHvvTwZHdOZ3PFYKgapUNM+InlI/qJoqXVzRC1nNwVbFuFBj8qJwsDVkM1KfV9VthDHOnUc3X//K08ZTpQJBAO9/I3fy2GybbUJCtK4PSYpTuVTxzoF3cLn87yfb9m/2DLfG5msjyekLRQqfdQ9Cr6Kgif5xdlYhpiS6ho1Yu6cCQQDr2eYGcO+pYEL+SqVQX5jQaK4zzW3eUymZwtDYnUPUun0kLd85/nrsSUrdRmSyHQpPaH5O0tUdhqN4fB//kNezAkAEgm5WidoNYXfTMZJZXKxT0HPC57KtuWQD/IE8TOX9AbMHmtUn20qn+rBYHNyFZwoLk95FTjmeMZABTQnPi4YtAkA7AjiQEf+UhBYe43Q7CMAGHLrBETvU7T+yTdDM8YQAHGyk+akpLGd66NeHR054VdW3inBXrl5N1drekUe8PHQLAkAex7ygit6Bdx5wep0BXseB2bJXJa9lGtFZ2GoEhLwI6wsIf4GprRSjnfsTAtsq57T0ntb2pevteLiUxvgHPuUk"]);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
