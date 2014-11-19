#import "Currency.h"

@implementation Currency
@dynamic baseIsoCode;
@dynamic isoCode;
@dynamic displayName;
@dynamic rate;
@dynamic updatedAt;

- (NSDictionary *)remoteMapping {
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{
                    @"baseIsoCode" : @"base_iso_code",
                    @"isoCode" : @"iso_code",
                    @"displayName" : @"display_name",
                    @"rate" : @"rate",
                    @"updateAt" : @"updated_at"
                    };
    });
    return mapping;
}

- (NSString *)baseIsoCode {
    return [self valueForKey:[self remoteMapping][NSStringFromSelector(_cmd)]];
}

- (NSString *)isoCode {
    return [self valueForKey:[self remoteMapping][NSStringFromSelector(_cmd)]];
}

- (NSString *)displayName {
    return [self valueForKey:[self remoteMapping][NSStringFromSelector(_cmd)]];
}

- (NSDate *)updatedAt {
    return [self valueForKey:[self remoteMapping][NSStringFromSelector(_cmd)]];
}

+ (NSString *)parseClassName {
    return @"Currency";
}

@end
