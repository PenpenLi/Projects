/************************************************************************/
/*                                                                      */
/************************************************************************/
#ifndef __BASE_NET_MESSAGE_PROTOCOL_DELEGATE_H__
#define __BASE_NET_MESSAGE_PROTOCOL_DELEGATE_H__

#include "cocos2d.h"
#include <sys/stat.h>
//#include "Downloader.h"

class IMessageProtocolDelegate
{
public:
    IMessageProtocolDelegate() {}
    ~IMessageProtocolDelegate() {}

    virtual void process(unsigned int connIndex, const char *szBuff, size_t size) 
    { CC_UNUSED_PARAM(connIndex);CC_UNUSED_PARAM(szBuff);CC_UNUSED_PARAM(size); }

    virtual void onConnectSuccess(unsigned int connIndex) 
    { CC_UNUSED_PARAM(connIndex); }

    virtual void onConnectFail(unsigned int connIndex)
    { CC_UNUSED_PARAM(connIndex); }

    virtual void onConnectBroken(unsigned int connIndex)
    { CC_UNUSED_PARAM(connIndex); }
    
    virtual void onConnectClose(unsigned int connIndex)
    { CC_UNUSED_PARAM(connIndex); }

    // ���������������ݵİ��� 
    // Ĭ�ϴ��������ȡ��������ͷ4�ֽڣ��������ֽ���ת�ɱ����ֽ�����Ϊ���� 
    // ���� @len ���� true
    //     ͨ�������趨�İ�ͷ�ṹͷ���ֽ��ǰ�������Ȼ����ͬЭ����ܰ�ͷ�ṹ�� 
    //     һ���������Ҫ��д���������������ȷ�İ������������false���򽫻� 
    //     ��һ��selectȡ�����������ݷ���circle queue���⽫�е����յ��������� 
    //     ʱ���ִ��ҵĿ��ܡ� 
    virtual bool parseBufferLen(unsigned int connIndex, 
        const char *szBuff, size_t size, unsigned int &len) 
    { 
        if (size > 4) 
        {
            len = ntohl(*reinterpret_cast<const unsigned int*>(szBuff));
            return true;
        }
        return false;
    }

    virtual void onException(const std::string &e_what) 
    { CC_UNUSED_PARAM(e_what); }

  //  virtual void onDownloaded(const net::stDownloadUrl &downloaded) 
 //   { CC_UNUSED_PARAM(downloaded); }
};

#endif
