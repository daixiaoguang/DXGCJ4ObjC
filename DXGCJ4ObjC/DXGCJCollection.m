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

#import "DXGCJCollection.h"
#import "DXGCJLink.h"
#import "DXGCJError.h"

@interface DXGCJCollection ()

@end

@implementation DXGCJCollection

+ (DXGCJCollection *)collectionWithData:(NSData *)data
                                  error:(NSError **)error {
    if (!data) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1001
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Empty Data!" }];
        }
        return nil;
    }
    
    NSError *internalError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&internalError];
    if (internalError) {
        NSLog(@"%@", internalError);
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1002
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Invalid JSON Object!" }];
        }
        return nil;
    }
    
    NSDictionary *cjDictionary = json[@"collection"];
    if (cjDictionary) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1003
                                     userInfo:@{ NSLocalizedDescriptionKey: @"No collection object!" }];
        }
        return nil;
    }
    
    DXGCJCollection *collection = [[DXGCJCollection alloc] init];
    
    // version property
    collection.version = cjDictionary[@"version"];
    if (!collection.version) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1004
                                     userInfo:@{ NSLocalizedDescriptionKey: @"No version property in collection object!" }];
        }
        return nil;
    }
    
    // href property
    collection.href = [NSURL URLWithString:cjDictionary[@"href"]];
    if (!collection.href) {
        if (error) {
            *error = [NSError errorWithDomain:@"Collection+JSON"
                                         code:1005
                                     userInfo:@{ NSLocalizedDescriptionKey: @"No href property in collection object!" }];
        }
        return nil;
    }

    // links array
    collection.links = [DXGCJLink linksWithCJDictionary:cjDictionary
                                                  error:&internalError];
    if (internalError) {
        if (error) {
            *error = internalError;
        }
        return nil;
    }
    
    // error object
    collection.error = [DXGCJError errorWithCJDictionary:cjDictionary
                                                   error:&internalError];
    if (internalError) {
        if (error) {
            *error = internalError;
        }
        return nil;
    }
    
    
    return collection;
}

@end
