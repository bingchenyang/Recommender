//
//  DianPingEngine.h
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
//1.	Prepare your URL from the parameters.
//2.	Create a MKNetworkOperation object for the request.
//3.	Set your method parameters.
//4.	Add completion and error handlers to the operation (The completion handler is the place to process your responses and convert them to Models.)
//5.	Optionally, add progress handlers to the operation. (Or do this on the view controller)
//6.	If your operation is file download, set a download stream (normally a file) to it. This is again optional.
//7.	When the operation completes, process the result and invoke the block method to return this data to the calling method.
//

//名称            类型          说明
//appkey        string      App Key，应用的唯一标识
//sign          string      请求签名，生成方式见《API请求签名生成文档》
//可选参数
//名称            类型          说明
//latitude      float       纬度坐标，须与经度坐标同时传入，与城市名称二者必选其一传入
//longitude     float       经度坐标，须与纬度坐标同时传入，与城市名称二者必选其一传入
//offset_type	int         偏移类型，0:未偏移，1:高德坐标系偏移，2:图吧坐标系偏移，如不传入，默认值为0
//radius        int         搜索半径，单位为米，最小值1，最大值5000，如不传入默认为1000
//city          string      城市名称，可选范围见相关API返回结果，与经纬度坐标二者必选其一传入
//region        string      城市区域名，可选范围见相关API返回结果（不含返回结果中包括的城市名称信息），如传入城市区域名，则城市名称必须传入
//category      string      分类名，可选范围见相关API返回结果
//keyword       string      关键词，搜索范围包括商户名、地址、标签等
//out_offset_type	 int	传出经纬度偏移类型，1:高德坐标系偏移，2:图吧坐标系偏移，如不传入，默认值为1
//platform      int         传出链接类型，1:web站链接（适用于网页应用），2:HTML5站链接（适用于移动应用和联网车载应用），如不传入，默认值为1
//has_coupon    int         根据是否有优惠券来筛选返回的商户，1:有，0:没有
//has_deal      int         根据是否有团购来筛选返回的商户，1:有，0:没有
//sort          int         结果排序，1:默认，2:星级高优先，3:产品评价高优先，4:环境评价高优先，5:服务评价高优先，6:点评数量多优先，7:离传入经纬度坐标距离近优先
//limit         int         每页返回的商户结果条目数上限，最小值1，最大值20，如不传入默认为20
//page          int         页码，如不传入默认为1，即第一页
//format        string      返回数据格式，可选值为json或xml，如不传入，默认值为json

#import "MKNetworkEngine.h"

//结果排序，1:默认，2:星级高优先，3:产品评价高优先，4:环境评价高优先，5:服务评价高优先，6:点评数量多优先，7:离传入经纬度坐标距离近优先
typedef enum {
    DianPingSortTypeDefault = 1,
    DianPingSortTypeRating = 2,
    DianPingSortTypePraise = 3,
    DianPingSortTypeEnvironment = 4,
    DianPingSortTypeService = 5,
    DianPingSortTypeReview = 6,
    DianPingSortTypeDistance = 7
} DianPingSortType;

typedef void (^DPResponseBlock)(NSArray *businesses);

@interface DianPingEngine : MKNetworkEngine

-(id) init;

-(MKNetworkOperation *)findPoi:(NSString *)keyword
                        inCity:(NSString *)city
                          page:(NSInteger)page
                          sort:(DianPingSortType)sort
                  onCompletion:(DPResponseBlock) completion
                       onError:(MKNKErrorBlock) onError;

@end
