#ifndef __MESSAGE_QUEUE_CIRCLE_QUEUE_H__
#define __MESSAGE_QUEUE_CIRCLE_QUEUE_H__

#include <stdint.h>
//#include <inttypes.h>
#include <stddef.h>
#include <time.h>
#include <string.h>
#include "common_define.h"

#define CIRCLEQUEUE_REVERSE_SIZE	64
class CCircleQueue
{
public:

	enum
	{
		invalid_offset = -1, 
		reserved_length = 8,
		queue_buffer_is_not_enough = 2,
		queue_is_empty			   = 3,	
		recv_buffer_is_not_enough  = 4,	
		queue_is_not_ini		   = 5,	
	};
	CCircleQueue();
	CCircleQueue(void* pBuffer, uint32_t nLen, bool bIgnoreScrap = true, bool bReserve = true);
	~CCircleQueue(void);
	char* reset(void* pBuffer, uint32_t nLen, bool bIgnoreScrap = true, bool bReserve = true);

protected://attributes 
	volatile uint32_t m_iSize;
	volatile uint32_t m_iHead;
	volatile uint32_t m_iTail;
	volatile uint32_t m_iPush;
	volatile uint32_t m_iPop;

	uint32_t m_iReserve;

	char*			m_pBuffer;
	const uint32_t	m_ciNodeHeadLen;
	bool m_bIgnoreScrap;

public:
	void initialize();

	int32_t append(const char* code, uint32_t size);


	int32_t pop(char* dst, uint32_t& outlength);

	const char* get(uint32_t& outlength);
	int32_t pop();
	uint32_t get_count();


	int32_t pop_from(int32_t offset, int32_t codesize, char* dst, int32_t& outlenght);


	bool full(void);


	bool empty(void);
	
	void clear(void);

protected:
	int32_t code_offset(void)const;

	int32_t set_boundary(uint32_t head, uint32_t tail);
    int32_t set_head(uint32_t head);
    int32_t set_tail(uint32_t tail);

	int32_t get_boundary(uint32_t& head, uint32_t& tail);

	char* get_codebuffer(void)const;

	int32_t append1(const char* code, uint32_t size);
	int32_t append2(const char* code, uint32_t size);
	int32_t pop1(char* dst, uint32_t& outlength);
	int32_t pop2(char* dst, uint32_t& outlength);

public:
	uint32_t get_freesize(void);

	uint32_t get_codesize(void);

};

#endif

