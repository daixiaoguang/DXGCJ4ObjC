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

#import "DXGCJLink.h"

@implementation DXGCJLink

+ (NSArray *)linksWithCJDictionary:(NSDictionary *)dictionary
                             error:(NSError **)error {
    if (!dictionary) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1101
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Empty collection dictionary!" }];
        }
        return nil;
    }
    
    if (!dictionary[@"links"] || [dictionary[@"links"] count] == 0) {
        return nil;
    }
    
    NSMutableArray *links = [NSMutableArray arrayWithCapacity:[dictionary[@"links"] count]];
    __block NSError *internalError;
    
    [dictionary[@"links"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DXGCJLink *link = [DXGCJLink linkWithDictionary:obj error:&internalError];
        if (internalError) {
            *error = internalError;
            *stop = YES;
        } else {
            [links addObject:link];
        }
    }];
    
    if (internalError) {
        return nil;
    }
    
    return links;
}

+ (DXGCJLink *)linkWithDictionary:(NSDictionary *)dictionary
                            error:(NSError **)error {
    if (!dictionary || [dictionary count] == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1102
                                     userInfo:@{ NSLocalizedDescriptionKey: @"No link object!" }];
        }
        return nil;
    }
    
    if (!dictionary[@"href"]) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1103
                                     userInfo:@{ NSLocalizedDescriptionKey: @"No href property in link object!" }];
        }
        return nil;
    }
    
    if (!dictionary[@"rel"]) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1104
                                     userInfo:@{ NSLocalizedDescriptionKey: @"No rel property in link object!" }];
        }
        return nil;
    }
    
    DXGCJLink *link = [[DXGCJLink alloc] init];
    
    link.href   = dictionary[@"href"];
    link.rel    = dictionary[@"rel"];
    link.name   = dictionary[@"name"];
    link.render = dictionary[@"render"];
    link.prompt = dictionary[@"prompt"];
    
    return link;
}

@end
