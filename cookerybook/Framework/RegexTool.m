//
//  TextCheckTool.m
//  sibu
//
//  Created by l.h on 14-8-22.
//  Copyright (c) 2014年 com.gzsibu. All rights reserved.
//

#import "RegexTool.h"

@implementation RegexTool

+ (BOOL) isEmptyOrNull:(NSString*) string
{
    return ![self notEmptyOrNull:string];
    
}

+ (BOOL) notEmptyOrNull:(NSString*) string
{
    if([string isKindOfClass:[NSNull class]])
        return NO;
    if ([string isKindOfClass:[NSNumber class]]) {
        if (string != nil) {
            return  YES;
        }
        return NO;
    } else {
        string=[self trimString:string];
        if (string != nil && string.length > 0 && ![string isEqualToString:@"null"]&&![string isEqualToString:@"(null)"]&&![string isEqualToString:@" "]) {
            return  YES;
        }
        return NO;
    }
}


+ (NSString *)trimString:(NSString *) str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



//校验用户手机号码
+ (BOOL) validateUserPhone : (NSString *) str
{
    ////参考来源：http://hotfm.iteye.com/blog/1208366
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|2|3|5|6|7|8|9])\\d{8}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    if(numberofMatch > 0)
    {
        NSLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    //    [Dialog  toast:@"你输入的手机号不正确"];
    NSLog(@"%@ isNumbericString: NO", str);
    return NO;
}


//校验Email  带有域名验证
+(BOOL)validateEmail:(NSString *)_text
{
    NSString *Regex=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    
    return [emailTest evaluateWithObject:_text];
    
}



///验证内容是否符合指定正值表达式的格式
//正则格式：NSString * regex = @"[A-Za-z0-9]{0,}";
+ (BOOL)validateValue:(NSString *)content
            withRegex:(NSString *)regexString
{
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [regExPredicate evaluateWithObject:content] ;
}

+ (NSString *) datetimeStrFormatter:(NSString *)dateStr formatter:(NSString *)formatterStr
{
    if(dateStr ==nil)
    {
        return @"";
    }
    
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[dateStr floatValue]];
    
    NSDateFormatter *displayTimeFormatter = [[NSDateFormatter alloc]init];
    //[displayTimeFormatter setDateFormat:@"yyyy-MM-dd"];
    if([formatterStr isEqualToString:@"yyyy-MM-dd"]
       ||[formatterStr isEqualToString:@"yyyy-MM-dd HH:mm"]
       ||[formatterStr isEqualToString:@"yyyy-MM-dd HH:mm:ss"]
       ||[formatterStr isEqualToString:@"yyyy.MM.dd"])
    {
        [displayTimeFormatter setDateFormat:[NSString stringWithString:formatterStr]];
    }
    else
    {
        [displayTimeFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString *formatterTimeStr= [NSString stringWithFormat:@"%@", [displayTimeFormatter stringFromDate:dateTime]];
   
    return formatterTimeStr;
}


+ (BOOL)validateMobile:(NSString *)mobileNum
{
    //参考来源:http://southking.iteye.com/blog/1747672
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//是否为中文
+(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}



+(BOOL)checkUrl:(id)_strInput
{
    NSString  *_strRegex = @"^(http|https|ftp)://[a-zA-Z0-9]+[.][a-zA-Z0-9]+([.][a-zA-Z0-9]+){0,1}(/[a-zA-Z0-9-_.+=?&%]*)*$";
    NSPredicate*   _predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",_strRegex];
    if ([_predicate evaluateWithObject:_strInput]) {
        return YES;
    }else{
       return NO;
    }
}


@end
