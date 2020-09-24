


#import <Foundation/Foundation.h>

@interface Define : NSObject

#define S_WIDTH   [UIScreen mainScreen].bounds.size.width
#define S_HEIGHT [UIScreen mainScreen].bounds.size.height

#define RECT_WEIGHT 44

#define RECT_WEIGHT_able 44


#define RECT_RADIUS RECT_WEIGHT/2

#define RECT_RADIUS_SPACE (S_HEIGHT > 667 ? 61 :40)


#define RECT_LINE_WEIGHT 2


#define RECT_BORDER 1


#define RECT_BACKGROUND [UIColor whiteColor]


#define RECT_VCBACKGROUND [UIColor colorWithRed:244.0/255.0   green:244.0/255.0   blue:244.0/255.0   alpha:1]


#define RECT_COLORDONE [UIColor colorWithRed:114.0/255.0   green:161.0/255.0   blue:250.0/255.0   alpha:1]


#define RECT_COLORSELECT  [UIColor colorWithRed:89.0/255.0   green:146.0/255.0   blue:254.0/255.0   alpha:1]


#define RECT_TIPCOLORNOMOR [UIColor grayColor]


#define RECT_TIPCOLORFAILD [UIColor redColor]


#define RECT_HEADVIEWCOLOR [UIColor grayColor]

@end
