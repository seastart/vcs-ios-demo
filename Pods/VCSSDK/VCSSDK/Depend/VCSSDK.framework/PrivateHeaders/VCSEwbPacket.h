#pragma once
#include <string>

class VCSEwbPacket
{
public:
	VCSEwbPacket();
	VCSEwbPacket(short cmd, const std::string& data);

	void SetCommand(short cmd) {
		m_cmd = cmd;
	}

	short GetCommand() const {
		return m_cmd;
	}

	void SetData(const std::string& data) {
		m_data = data;
	}

	void SetData(const char* data, size_t size) {
		m_data.assign(data, size);
	}

	const std::string& GetData() const {
		return m_data;
	}

	static int Parse(const char* buf, int offset, int len, VCSEwbPacket* pkt);
	std::string ToByteArray() const;

private:
	short m_cmd;
	std::string m_data;
};

