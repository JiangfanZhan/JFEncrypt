//
//  JFDESEncrypt.m
//  JFDESEncrypt
//
//  Created by JiangfanZhan on 2017/2/4.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import "JFDESEncrypt.h"


@implementation JFDESEncrypt

const Byte iv[] = {1,2,3,4,5,6,7,8};


/**
 加密方法
 */
+(NSString *) encrypt:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    
    bufferPtrSize = (dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [textData bytes],
                                          dataLength,
                                          bufferPtr, bufferPtrSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:bufferPtr length:(NSUInteger)numBytesEncrypted];
        ciphertext = [GTMBase64 stringByEncodingData:data];
    }
    return ciphertext;
}


/**
 解密方法
 */
+(NSString *)decrypt:(NSString *)cipherText key:(NSString *)key;
{
    NSString *plaintext = nil;
    NSData *cipherdata = [GTMBase64 decodeData:[cipherText dataUsingEncoding:NSUTF8StringEncoding]];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    
    bufferPtrSize = ([cipherdata length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          bufferPtr, bufferPtrSize,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:bufferPtr length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

/**
 加解密方法
 */
+(NSString *)cipher:(NSString*)plainText operation:(CCOperation)encryptOrDecrypt key:(NSString *)key
{
    const void * vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt== kCCDecrypt)
    {
        NSData * EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        
        plainTextBufferSize= [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData * tempData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize= [tempData length];
        vplainText = [tempData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES)
    &~(kCCBlockSizeDES- 1);
    
    bufferPtr = malloc(bufferPtrSize* sizeof(uint8_t));
    memset((void*)bufferPtr,0x0, bufferPtrSize);
    
    const void * vkey= (const void *)[key UTF8String];
    
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey, //key
                       kCCKeySizeDES,
                       iv,
                       vplainText,//plainText,
                       plainTextBufferSize,
                       (void*)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    if (ccStatus== kCCParamError) return @"PARAM ERROR";
    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    
    NSString * result;
    
    if (encryptOrDecrypt== kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData
                                                 dataWithBytes:(const void *)bufferPtr
                                                 length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData * myData =[NSData dataWithBytes:(const void *)bufferPtr
                                        length:(NSUInteger)movedBytes];
        
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
    
}


@end
