//
//  JFDESEncrypt.h
//  JFDESEncrypt
//
//  Created by JiangfanZhan on 2017/2/4.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
#import "GTMDefines.h"
#import <CommonCrypto/CommonCryptor.h>

#define KDESEncryptKey @"DES_Jeffrey"

@interface JFDESEncrypt : NSObject

/**
 * 加密
 * @param plainText 待加密明文
 * @param key       密钥
 */
+(NSString *) encrypt:(NSString *)plainText key:(NSString *)key;

/**
 * 解密
 * @param cipherText 待解密密文
 * @param key        密钥
 */
+(NSString *)decrypt:(NSString *)cipherText key:(NSString *)key;

/**
 * 加解或解密
 * @param plainText        待加密或解密的文本
 * @param encryptOrDecrypt 加密或解密枚举值
 * @param key              密钥
 */
+(NSString *)cipher:(NSString*)plainText operation:(CCOperation)encryptOrDecrypt key:(NSString *)key;

@end
