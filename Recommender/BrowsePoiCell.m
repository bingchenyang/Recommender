//
//  BrowsePoiCell.m
//  Recommender
//
//  Created by Benson Yang on 9/1/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowsePoiCell.h"

@interface BrowsePoiCell ()
@property (nonatomic, strong) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) IBOutlet UIImageView *ratingView;
@property (nonatomic, strong) IBOutlet UILabel *nameLable;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@end

@implementation BrowsePoiCell

- (void)setPhoto:(UIImage *)photo {
    if (self.photoView.image != photo) {
        self.photoView.image = photo;
        _photo = photo;
    }
}

- (void)setRating:(UIImage *)rating {
    if (self.ratingView.image != rating) {
        self.ratingView.image = rating;
        _rating = rating;
    }
}

- (void)setName:(NSString *)name {
    if (![self.nameLable.text isEqualToString:name]) {
        CGSize size = [name sizeWithFont: self.nameLable.font];
        self.nameLable.frame = CGRectMake(168, 2, size.width, size.height);
        self.nameLable.text = name;
    }
}

- (void)setDescription:(NSString *)description {
    if (![self.descriptionLabel.text isEqualToString: description]) {
        CGSize size = [description sizeWithFont: self.descriptionLabel.font];
        self.descriptionLabel.frame = CGRectMake(168, 30, size.width, size.height);
        self.descriptionLabel.text = description;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(168 , 2, 46, 21)];
//        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(168, 30, 42, 21)];
//        self.ratingView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 80, 120, 20)];
//        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 120)];
//        
//        [self.contentView addSubview:self.nameLable];
//        [self.contentView addSubview:self.descriptionLabel];
//        [self.contentView addSubview:self.ratingView];
//        [self.contentView addSubview:self.photoView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
