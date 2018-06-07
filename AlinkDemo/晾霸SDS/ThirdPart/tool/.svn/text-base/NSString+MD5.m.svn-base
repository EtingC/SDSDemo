//
//  NSString+MD5.m
//  FanLingDuDemo
//
//  Created by gubeidianzi on 2017/10/12.
//  Copyright © 2017年 gubeidianzi. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)
- (id)MD5
 {
        const char *cStr = [self UTF8String];
       unsigned char digest[16];
       unsigned int x=(int)strlen(cStr) ;
       CC_MD5( cStr, x, digest );
       // This is the md5 call
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
   
       for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                [output appendFormat:@"%02x", digest[i]];
  
       return  output;
 
}
@end
