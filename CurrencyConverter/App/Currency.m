#import "Currency.h"

@implementation Currency
@dynamic baseIsoCode;
@dynamic isoCode;
@dynamic displayName;
@dynamic rate;
@dynamic updatedAt;



+ (NSString *)parseClassName {
    return @"Currency";
}

@end
