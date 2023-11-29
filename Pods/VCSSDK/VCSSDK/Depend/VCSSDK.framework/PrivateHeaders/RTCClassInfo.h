//
//  RTCClassInfo.h
//  RTCEngineKit
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/// 类型编码类型
typedef NS_OPTIONS(NSUInteger, RTCEncodingType) {
    
    RTCEncodingTypeMask       = 0xFF, /// < mask of type value
    RTCEncodingTypeUnknown    = 0, /// < unknown
    RTCEncodingTypeVoid       = 1, /// < void
    RTCEncodingTypeBool       = 2, /// < bool
    RTCEncodingTypeInt8       = 3, /// < char / BOOL
    RTCEncodingTypeUInt8      = 4, /// < unsigned char
    RTCEncodingTypeInt16      = 5, /// < short
    RTCEncodingTypeUInt16     = 6, /// < unsigned short
    RTCEncodingTypeInt32      = 7, /// < int
    RTCEncodingTypeUInt32     = 8, /// < unsigned int
    RTCEncodingTypeInt64      = 9, /// < long long
    RTCEncodingTypeUInt64     = 10, /// < unsigned long long
    RTCEncodingTypeFloat      = 11, /// < float
    RTCEncodingTypeDouble     = 12, /// < double
    RTCEncodingTypeLongDouble = 13, /// < long double
    RTCEncodingTypeObject     = 14, /// < id
    RTCEncodingTypeClass      = 15, /// < Class
    RTCEncodingTypeSEL        = 16, /// < SEL
    RTCEncodingTypeBlock      = 17, /// < block
    RTCEncodingTypePointer    = 18, /// < void*
    RTCEncodingTypeStruct     = 19, /// < struct
    RTCEncodingTypeUnion      = 20, /// < union
    RTCEncodingTypeCString    = 21, /// < char*
    RTCEncodingTypeCArray     = 22, /// < char[10] (for example)
    
    RTCEncodingTypeQualifierMask   = 0xFF00,   /// < mask of qualifier
    RTCEncodingTypeQualifierConst  = 1 << 8,  /// < const
    RTCEncodingTypeQualifierIn     = 1 << 9,  /// < in
    RTCEncodingTypeQualifierInout  = 1 << 10, /// < inout
    RTCEncodingTypeQualifierOut    = 1 << 11, /// < out
    RTCEncodingTypeQualifierBycopy = 1 << 12, /// < bycopy
    RTCEncodingTypeQualifierByref  = 1 << 13, /// < byref
    RTCEncodingTypeQualifierOneway = 1 << 14, /// < oneway
    
    RTCEncodingTypePropertyMask         = 0xFF0000, /// < mask of property
    RTCEncodingTypePropertyReadonly     = 1 << 16, /// < readonly
    RTCEncodingTypePropertyCopy         = 1 << 17, /// < copy
    RTCEncodingTypePropertyRetain       = 1 << 18, /// < retain
    RTCEncodingTypePropertyNonatomic    = 1 << 19, /// < nonatomic
    RTCEncodingTypePropertyWeak         = 1 << 20, /// < weak
    RTCEncodingTypePropertyCustomGetter = 1 << 21, /// < getter=
    RTCEncodingTypePropertyCustomSetter = 1 << 22, /// < setter=
    RTCEncodingTypePropertyDynamic      = 1 << 23, /// < @dynamic
};

/// 从类型编码字符串获取类型
/// @param typeEncoding 类型编码字符串
RTCEncodingType RTCEncodingGetType(const char *typeEncoding);


/// 实例可变信息。
@interface RTCClassIvarInfo : NSObject

@property (nonatomic, assign, readonly) Ivar ivar;              /// < ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         /// < Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       /// < Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; /// < Ivar's type encoding
@property (nonatomic, assign, readonly) RTCEncodingType type;   /// < Ivar's type

/// 创建并返回 ivar 信息对象
/// @param ivar Ivar
- (instancetype)initWithIvar:(Ivar)ivar;

@end


/// 方法信息
@interface RTCClassMethodInfo : NSObject

@property (nonatomic, assign, readonly) Method method;                  /// < method opaque struct
@property (nonatomic, strong, readonly) NSString *name;                 /// < method name
@property (nonatomic, assign, readonly) SEL sel;                        /// < method's selector
@property (nonatomic, assign, readonly) IMP imp;                        /// < method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding;         /// < method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   /// < return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; /// < array of arguments' type

/// 创建并返回方法信息对象
/// @param method Method
- (instancetype)initWithMethod:(Method)method;

@end


/// 财产信息
@interface RTCClassPropertyInfo : NSObject

@property (nonatomic, assign, readonly) objc_property_t property; /// < property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           /// < property's name
@property (nonatomic, assign, readonly) RTCEncodingType type;     /// < property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   /// < property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       /// < property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      /// < may be nil
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; /// < may nil
@property (nonatomic, assign, readonly) SEL getter;               /// < getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               /// < setter (nonnull)

/// 创建并返回属性信息对象
/// @param property objc_property_t
- (instancetype)initWithProperty:(objc_property_t)property;

@end


/// 类的类信息
@interface RTCClassInfo : NSObject

@property (nonatomic, assign, readonly) Class cls; /// < class object
@property (nullable, nonatomic, assign, readonly) Class superCls; /// < super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  /// < class's meta class object
@property (nonatomic, readonly) BOOL isMeta;       /// < whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name;    /// < class name
@property (nullable, nonatomic, strong, readonly) RTCClassInfo *superClassInfo; /// < super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary <NSString *, RTCClassIvarInfo *> *ivarInfos;          /// < ivars
@property (nullable, nonatomic, strong, readonly) NSDictionary <NSString *, RTCClassMethodInfo *> *methodInfos;        /// < methods
@property (nullable, nonatomic, strong, readonly) NSDictionary <NSString *, RTCClassPropertyInfo *> *propertyInfos;      /// < properties


/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, `needUpdate` will returns `YES`, and you should call
 'classInfoWithClass' or 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
