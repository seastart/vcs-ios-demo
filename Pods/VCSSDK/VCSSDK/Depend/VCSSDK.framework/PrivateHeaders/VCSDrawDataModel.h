#ifndef VCSDrawDataModel_H
#define VCSDrawDataModel_H

#include <uuid/uuid.h>
#include <vector>
#include <string>
//#include <stdlib.h>

namespace drawing {

// 位置点
class Position
{
public:
    // 本地画布坐标
    float x;
    float y;
    
    // 服务端画布坐标
    float ratio_x;
    float ratio_y;
    
    // 画布大小
    void setSize(int inWidth, int inHeight);
};

// 颜色(255)
struct Color
{
    int r;
    int g;
    int b;
};

struct PathDataModel
{
public:
    // 唯一标识
    long long id;
    
    // 用户标识
    std::string userId;
    
    // 类型
    int type;
    
    // 画笔宽度(如果是文字则用来控制字体大小)
    float penWidth;
    
    // 服务端画笔宽度(如果是文字则用来控制字体大小)
    float ratioPenWidth;
    
    // 画笔透明度
    int alpha;
    
    // 画笔颜色
    Color color;
    
    // 形状
    std::vector<Position> positions;
    
    // 内容(如果是文字用来记录内容)
    std::string content;
    
    // 画布大小
    void setSize(int inWidth, int inHeight);
    
    // 身份是否相同
    bool isEqual(const PathDataModel& model);
};

class PainterPathModel
{
public:
    PainterPathModel();
    
    // 画布大小
    void setSize(int inWidth, int inHeight);
    
    // 当前绘制完成，切换到下一步
    void next();
    
    // 设置id
    void setId();
    
    // 设置类型
    void setType(int type);
    
    // 设置画笔大小
    void setPenWidth(int penWidth);
    
    // 设置透明度（255）
    void setAlpha(int alpha);
    
    // 设置颜色
    void setColor(int r, int g, int b);
    
    // 添加点
    void addPosition(int x, int y);
    
    // 清除所有点
    void clear();
    
    // 获取矢量数据
    PathDataModel& getData();
    
private:
    
    // 矢量数据
    PathDataModel data;
    
    // 画布大小
    int width;
    int height;
    
    // 生成uuid
    std::string generate();
    
    // 生成绘制画笔ID
    long long randomDrawId();
};

}
#endif // VCSDrawingBoard_H
