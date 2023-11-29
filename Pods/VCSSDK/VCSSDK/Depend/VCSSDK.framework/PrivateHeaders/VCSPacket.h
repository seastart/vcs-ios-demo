//
//  VCSPacket.h
//  VCSSDK
//
//  Created by SailorGa on 2020/4/27.
//

#pragma once
#include <string>

#define PACKET_HEADSIZE          12
#define PACKET_MAGIC_CODE        '$'

class VCSPacket {
    
public:
    
    VCSPacket();
    VCSPacket(short cmd, const char* data, unsigned short data_size, char type, unsigned short major=0, unsigned short minor=0, short result=0);
    ~VCSPacket();
    
    char type()const { return m_type; }
    void set_type(char type) { m_type = type; }
    
    short command()const { return m_cmd; }
    void set_command(short cmd) { m_cmd = cmd; }
    
    unsigned short major()const { return m_major; }
    void set_major(unsigned short major) { m_major = major; }
    
    unsigned short minor()const { return m_minor; }
    void set_minor(unsigned short minor) { m_minor = minor; }
    
    short result()const { return m_result; }
    void set_result(short result) { m_result = result; }
    
    void set_data(const char* data, unsigned short data_size) {
        m_data.assign(data, data_size);
    }
    const std::string& data() const{
        return m_data;
    }
    
    
    bool to_bytes_array(std::string& buf) const;
    static int parse(const char* buffer,int buf_size, int pos, VCSPacket* packet);
    
private:
    
    char  m_type;
    short m_cmd;
    short m_result;
    unsigned short m_major;
    unsigned short m_minor;
    std::string m_data;
};
