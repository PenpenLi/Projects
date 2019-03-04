#ifndef __MESSAGE_QUEUE_COMMON_DEFINE_H__
#define __MESSAGE_QUEUE_COMMON_DEFINE_H__

enum
{
    success = 0,
    fail = 1,
    error = -1,
};

enum 
{
    max_game_tag_length				= 32,
    max_game_para_length			= 32,
    max_account_string_length		= 32,
    max_passwd_string_length        = 32,
    max_nickname_length				= 64,
    max_present_message_length		= 302, 
    max_system_message_length		= 4096,	
    max_reason_message_length		= 4096, 
    max_operate_description_length	= 64,  
    max_transparent_data_size		= 4096,
    max_crypt_string_length			= 128, 
    max_sub_message_size			= 4096,	
    max_qun_crypt_length			= 2048,
    max_profile_crypt_length		= 2048,
    max_web_qun_count				= 32,	
    max_private_chat_length			= 3002,	
    max_loudspeaker_length			= 302,	
    max_match_describe_length       = 128, 
    max_rolename_length             = 32,  
    max_hero_item_string_length     = 512, 
    max_mail_content_length         = 2048,
    max_comment_length				= 128, 
    max_chat_content_length         = 1024,
    max_big_transparent_data_size		= 32768, 
    max_package_size = 0xffff,		

};
    
enum
{
    SUCCESS                             = 0,
    FAIL                                = 1,
};

enum //seconds in xxx
{
    MINUTE                              = 60,       //one minute
    HOUR                                = 3600,     //60*MINUTE, //one hour
    DAY	                                = 86400,    //24*HOUR,	//one day
    YEAR                                = 31536000, //365*DAY	//one year
};

enum enm_desc_length
{
    MAX_DATETIME_STRING_LENGTH          = 36,      
    MAX_FILE_NAME_LENGTH                = 255,		
    MAX_PATH_LENGTH                     = 255,		
    MAX_IPADDR_LEN                      = 32,		
    MAX_ACCOUNT_STRING_LENGTH           = 48,       
    MAX_PASSWD_STRING_LENGTH            = 32,       
    MAX_PLAYER_NAME_LENGTH		        = 32,		
    MIN_PLAYER_NAME_LENGTH		        = 4,		
    MAX_URL_LENGTH				        = 128,		
    MAX_CHAT_MESSAGE_LENGTH	            = 512,	    
    MAX_SPEAK_MESSAGE_LENGTH	        = 512,	    
    MAX_MAIL_CONTENT_LENGTH             = 2048,     
    MAX_SYSTEM_MESSAGE_LENGTH           = 4096,	   
    MAX_BILL_MESSAGE_LENGTH             = 2048,	    
    MAX_TINY_DESC_LENGTH                = 36,       
    MAX_SHORT_DESC_LENGTH               = 128,     
    MAX_LONG_DESC_LENGTH                = 512,    

};

enum enm_desc_size
{
    MAX_TRANSPARENT_DATA_SIZE		    = 4096, 
    MAX_SETTED_TIMER_COUNT		        = 64,		
    MAX_COMMENT_SIZE				    = 128, 
};

#endif

