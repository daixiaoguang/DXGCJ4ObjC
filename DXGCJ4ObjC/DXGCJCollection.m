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



@property (strong, nonatomic) NSDictionary *template;
@property (strong, nonatomic) NSDictionary *error;

@end

@implementation DXGCJCollection

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                             error:(NSError **)error {
    self = [super init];
    if (self) {
        if (![NSJSONSerialization isValidJSONObject:dictionary]) {
            if (error) {
                NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey: @"Invalid JSON Object!" };
                *error = [NSError errorWithDomain:@"Collection+JSON"
                                             code:101
                                         userInfo:errorInfo];
            }
            
            return nil;
        }
        
        NSDictionary *collectionDictionary = dictionary[@"collection"];
        
        _version = [collectionDictionary[@"version"] copy];
        _href    = [collectionDictionary[@"href"] copy];

        NSArray *linksArray = collectionDictionary[@"links"];
        if (linksArray) {
            NSMutableArray *links = [NSMutableArray arrayWithCapacity:[collectionDictionary[@"links"] count]];
            [collectionDictionary[@"links"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                DXGCJLink *link = [[DXGCJLink alloc] initWithDictionary:obj];
                [links addObject:link];
            }];
            _links = [NSArray arrayWithArray:links];
        }

        NSDictionary *errorDictionary = collectionDictionary[@"error"];
        if (errorDictionary) {
            _error = [[DXGCJError alloc] initWithDictionary:errorDictionary];
        }
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data
                       error:(NSError **)error {
    self = [super init];
    if (self) {
        if (!data) {
            if (error) {
                NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey: @"Empty Data!" };
                *error = [NSError errorWithDomain:@"Collection+JSON"
                                             code:101
                                         userInfo:errorInfo];
            }
            
            return nil;
        }
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:nil];
        if (!dictionary) {
            if (error) {
                NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey: @"Invalid JSON Object!" };
                *error = [NSError errorWithDomain:@"Collection+JSON"
                                             code:101
                                         userInfo:errorInfo];
            }
            
            return nil;
        }
        
        NSDictionary *collectionDictionary = dictionary[@"collection"];
        
        _version = [collectionDictionary[@"version"] copy];
        _href    = [collectionDictionary[@"href"] copy];
        
        NSArray *linksArray = collectionDictionary[@"links"];
        if (linksArray) {
            NSMutableArray *links = [NSMutableArray arrayWithCapacity:[collectionDictionary[@"links"] count]];
            [collectionDictionary[@"links"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                DXGCJLink *link = [[DXGCJLink alloc] initWithDictionary:obj];
                [links addObject:link];
            }];
            _links = [NSArray arrayWithArray:links];
        }
        
        NSDictionary *errorDictionary = collectionDictionary[@"error"];
        if (errorDictionary) {
            _error = [[DXGCJError alloc] initWithDictionary:errorDictionary];
        }
    }
    
    return self;
}

@end
