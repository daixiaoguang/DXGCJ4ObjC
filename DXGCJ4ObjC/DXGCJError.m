// The MIT License (MIT)
//
// Copyright (c) 2015 Isaac Tai (xiaoguang.dai@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "DXGCJError.h"

@implementation DXGCJError

+ (DXGCJError *)errorWithCJDictionary:(NSDictionary *)dictionary
                                error:(NSError **)error {
    if (!dictionary) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1501
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Empty collection dictionary!" }];
        }
        return nil;
    }
    
    DXGCJError *cjError = [[DXGCJError alloc] init];
    
    cjError.title   = dictionary[@"error"][@"title"];
    cjError.code    = dictionary[@"error"][@"code"];
    cjError.message = dictionary[@"error"][@"message"];
    
    return cjError;
}

@end
