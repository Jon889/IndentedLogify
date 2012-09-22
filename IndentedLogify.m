//
//  IndentedLogify.m
//
//  Created by Jonathan Bailey on 22/09/2012.
//
//

#import "IndentedLogify.h"


@implementation NSString (IndentedLogify)


-(NSString *)indentString {
    NSString *str = self;
    int noOfSpaces = indentLevel *4;
    for (int i = 0; i < noOfSpaces; i++) {
        str = [@" " stringByAppendingString:str];
    }
    return str;
}

+(void)appendString:(NSString *)str toFileAtPath:(NSString *)path {
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
    if (fileHandler) {
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandler closeFile];
    } else {
        [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
@end

