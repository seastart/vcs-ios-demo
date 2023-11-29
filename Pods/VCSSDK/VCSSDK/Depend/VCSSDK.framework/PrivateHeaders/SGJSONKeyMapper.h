//
//  SGJSONKeyMapper.h
//  SGJSONModel
//

#import <Foundation/Foundation.h>

typedef NSString *(^SGJSONModelKeyMapBlock)(NSString *keyName);

/**
 * **You won't need to create or store instances of this class yourself.** If you want your model
 * to have different property names than the SGJSON feed keys, look below on how to
 * make your model use a key mapper.
 *
 * For example if you consume SGJSON from twitter
 * you get back underscore_case style key names. For example:
 *
 * <pre>"profile_sidebar_border_color": "0094C2",
 * "profile_background_tile": false,</pre>
 *
 * To comply with Obj-C accepted camelCase property naming for your classes,
 * you need to provide mapping between SGJSON keys and ObjC property names.
 *
 * In your model overwrite the + (SGJSONKeyMapper *)keyMapper method and provide a SGJSONKeyMapper
 * instance to convert the key names for your model.
 *
 * If you need custom mapping it's as easy as:
 * <pre>
 * + (SGJSONKeyMapper *)keyMapper {
 * &nbsp; return [[SGJSONKeyMapper&nbsp;alloc]&nbsp;initWithDictionary:@{@"crazy_SGJSON_name":@"myCamelCaseName"}];
 * }
 * </pre>
 * In case you want to handle underscore_case, **use the predefined key mapper**, like so:
 * <pre>
 * + (SGJSONKeyMapper *)keyMapper {
 * &nbsp; return [SGJSONKeyMapper&nbsp;mapperFromUnderscoreCaseToCamelCase];
 * }
 * </pre>
 */
@interface SGJSONKeyMapper : NSObject

// deprecated
@property (readonly, nonatomic) SGJSONModelKeyMapBlock SGJSONToModelKeyBlock DEPRECATED_ATTRIBUTE;
- (NSString *)convertValue:(NSString *)value isImportingToModel:(BOOL)importing DEPRECATED_MSG_ATTRIBUTE("use convertValue:");
- (instancetype)initWithDictionary:(NSDictionary *)map DEPRECATED_MSG_ATTRIBUTE("use initWithModelToSGJSONDictionary:");
- (instancetype)initWithSGJSONToModelBlock:(SGJSONModelKeyMapBlock)toModel modelToSGJSONBlock:(SGJSONModelKeyMapBlock)toSGJSON DEPRECATED_MSG_ATTRIBUTE("use initWithModelToSGJSONBlock:");
+ (instancetype)mapper:(SGJSONKeyMapper *)baseKeyMapper withExceptions:(NSDictionary *)exceptions DEPRECATED_MSG_ATTRIBUTE("use baseMapper:withModelToSGJSONExceptions:");
+ (instancetype)mapperFromUnderscoreCaseToCamelCase DEPRECATED_MSG_ATTRIBUTE("use mapperForSnakeCase:");
+ (instancetype)mapperFromUpperCaseToLowerCase DEPRECATED_ATTRIBUTE;

/** @name Name converters */
/** Block, which takes in a property name and converts it to the corresponding SGJSON key name */
@property (readonly, nonatomic) SGJSONModelKeyMapBlock modelToSGJSONKeyBlock;

/** Combined converter method
 * @param value the source name
 * @return SGJSONKeyMapper instance
 */
- (NSString *)convertValue:(NSString *)value;

/** @name Creating a key mapper */

/**
 * Creates a SGJSONKeyMapper instance, based on the block you provide this initializer.
 * The parameter takes in a SGJSONModelKeyMapBlock block:
 * <pre>NSString *(^SGJSONModelKeyMapBlock)(NSString *keyName)</pre>
 * The block takes in a string and returns the transformed (if at all) string.
 * @param toSGJSON transforms your model property name to a SGJSON key
 */
- (instancetype)initWithModelToSGJSONBlock:(SGJSONModelKeyMapBlock)toSGJSON;

/**
 * Creates a SGJSONKeyMapper instance, based on the mapping you provide.
 * Use your SGJSONModel property names as keys, and the SGJSON key names as values.
 * @param toSGJSON map dictionary, in the format: <pre>@{@"myCamelCaseName":@"crazy_SGJSON_name"}</pre>
 * @return SGJSONKeyMapper instance
 */
- (instancetype)initWithModelToSGJSONDictionary:(NSDictionary <NSString *, NSString *> *)toSGJSON;

/**
 * Given a camelCase model property, this mapper finds SGJSON keys using the snake_case equivalent.
 */
+ (instancetype)mapperForSnakeCase;

/**
 * Given a camelCase model property, this mapper finds SGJSON keys using the TitleCase equivalent.
 */
+ (instancetype)mapperForTitleCase;

/**
 * Creates a SGJSONKeyMapper based on a built-in SGJSONKeyMapper, with specific exceptions.
 * Use your SGJSONModel property names as keys, and the SGJSON key names as values.
 */
+ (instancetype)baseMapper:(SGJSONKeyMapper *)baseKeyMapper withModelToSGJSONExceptions:(NSDictionary *)toSGJSON;

@end
