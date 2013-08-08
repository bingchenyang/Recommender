//
//  AnnotationButton.m
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "AnnotationButton.h"

@implementation AnnotationButton

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 10, 10)];
    if (self) {
        self.tintColor = [UIColor redColor];
        [self setImage:[UIImage imageNamed:@"tablet_icon_selected_arrow.png"] forState:UIControlStateNormal];
        return self;
    }
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
