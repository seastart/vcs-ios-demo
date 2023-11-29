#pragma once
#import <thread>
#import <atomic>

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#import "VCSEwbPacket.h"

// 回调函数
typedef void(*VCSEwbClientPacket)(VCSEwbPacket*, void*);

// 超时回调函数
typedef void(*VCSEwbClientPacketTimeout)(bool);

struct OpenModel
{
	// 地址
	std::string address;

	// 商品号
	int port;

	// 房间id
	std::string roomId;

	// 用户id
	std::string userId;

	// 读写权限
	int privileges;

	// 宽高比
	float wh_ratio;
    
    // 画布背景图片
    std::string imageUrl;
};

// 电子白板客户端网络连接类
class VCSEwbClient
{
public:
	VCSEwbClient();
	
    // 连接的数据模型
	const OpenModel& getOpenModel() {
		return openModel;
	}

    // 打开连接
	bool Open(const OpenModel& model);
    
    // 关闭连接
	void Close();

    // 发送消息
	void Send(short cmd, const std::string& data);
    
    // 发送消息
	void Send(const VCSEwbPacket& pkt);

    // 设置数据回调
	void SetPacketEvent(VCSEwbClientPacket cbf, void* ctx) {
		m_cbf_packet = cbf;
		m_cbf_packet_ctx = ctx;
	}

    // 数据回调
	void InvokePacketEvent(VCSEwbPacket* pkt) {
		if (m_cbf_packet) {
			m_cbf_packet(pkt, m_cbf_packet_ctx);
		}
	}
    
    /// 超时数据回调
    void TimeoutEvent(VCSEwbClientPacketTimeout timeout) {
        timeoutCall = timeout;
    }

    // 进入房间
	bool Enter();
    
    // 心跳
	bool Heartbeat();
    
    // 退出
	bool Exit();

private:
    // 启动心跳
	void DoRun();
    
    // 启动收包
	void DoReceive();
    
    // 解包
	void OnPacket(VCSEwbPacket* pkt);
    
    // 连接服务
	bool Connect();
    
    // 更新时间戳
	void Update();
    
    // 是否超时
	bool IsTimeout();

private:
    // 是否活动
	bool m_active;
    
    // 是否连接过服务器
    bool is_connected;
    
    // 连接状态
	bool m_connected;
    
    // 计时器时间戳
	std::atomic_int64_t m_update;

    // 连接句柄
	int m_socket;

    // 心跳线程
	std::thread* m_runner;
    
    // 收包线程
	std::thread* m_receiver;

    // 连接数据模型
	OpenModel openModel;

    // 数据缓存
	std::string m_buffer;

    // 数据回调
	VCSEwbClientPacket m_cbf_packet;
    
    // 回调句柄
	void* m_cbf_packet_ctx;
    
    // 超时回调句柄
    VCSEwbClientPacketTimeout timeoutCall;
};
