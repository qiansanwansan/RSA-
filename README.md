# RSA- 加解密

根据博客：https://www.jianshu.com/p/74a796ec5038
所做记录，仅做学习，感谢原作者

以上能保证信息内容的不被泄漏，但是不能保证内容不被篡改，比如有心人截获了公钥，对假指令进行加密，再传递出去。所以不止要保证信息不会泄漏，同时也要保证信息不被篡改，此时可以采用签名/验签方式

  A->B
  
  A提取消息摘要（MD5？），并使用自己的私钥对摘要加密，生成签名
  
  A将签名和消息本身一起，使用B的公钥进行加密，生成密文，发送给B
  
  B接收到密文，使用自己的私钥解密得到消息本身和签名，此时消息已经到达B，但是不确认有无篡改
  
  B使用A的公钥对签名解密得到A对原消息的消息摘要，然后使用相同的方法对收到的消息提取消息摘要，两相比较，相同则验签成功，确认无篡改
