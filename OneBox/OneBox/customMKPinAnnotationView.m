

#import "customMKPinAnnotationView.h"

@implementation customMKPinAnnotationView
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self){
        
        if([UIScreen mainScreen].bounds.size.height<1100)
//            self.image=[self scaleToSize:[UIImage imageNamed:@"newMapIcon_new.png"] size:CGSizeMake(38*0.8, 45*0.8)];
//            self.image=[UIImage imageNamed:@"map_单个学校.png"];
//
//        else
//
//             self.image=[UIImage imageNamed:@"map_单个学校.png"];

//        _label=[[UILabel alloc]initWithFrame:CGRectMake(8.0f*_Scale, 2,40,40)];
            _label=[[UILabel alloc]initWithFrame:CGRectMake(2, 0,40,40)];
        _label.textAlignment=NSTextAlignmentCenter;

        _label.textColor=[UIColor whiteColor];
        _label.font=[UIFont fontWithName:@"Skia" size:20.0f];
        [self addSubview:_label];


    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
