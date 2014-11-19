#import <ParseOSX/Parse.h>

@interface Currency : PFObject<PFSubclassing>

@property (nonatomic) NSString *baseIsoCode;
@property (nonatomic) NSString *isoCode;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSNumber *rate;
@property (nonatomic) NSDate *updatedAt;

+ (NSString *)parseClassName;

@end
