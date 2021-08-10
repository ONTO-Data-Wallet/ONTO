// FaceModuleHead.h
#ifndef _Included_FaceModuleHead_
#define _Included_FaceModuleHead_

#define JY_FACESDK_EXPORTS
#ifdef	JY_FACESDK_EXPORTS
#	define	JY_FACE_API
#else
#   ifdef __cplusplus
#       define	JY_FACE_API extern 'C'
#   else//__cplusplus
#       define	JY_FACE_API extern
#   endif//__cplusplus
#endif//JY_FACESDK_EXPORTS

//传递给算法的灰度值buf，buf是从左上到右下排序，不进行4字节对齐
typedef struct tagInputGrayBufInfo
{
    unsigned char*   pGrayBuf;
    int     iWidth; //宽
    int     iHeight; //高
}SInputGrayBufInfo;

//把这帧原始照片buf传递给算法，由算法copy后保存，并最终用getSrcImgBuffer返回给上层
typedef struct tagScrImgInfo
{
    unsigned char*   pSrcImgBuf;
    int     iBufSize;
}SScrImgInfo;

enum eJYActionType
{
    eJAT_None = 0,
    eJAT_HeadLeft = 1,
    eJAT_HeadRight = 2,
    eJAT_HeadTop = 3,
    eJAT_HeadBottom = 4,
    eJAT_Mouth = 5,
    eJAT_Eye = 6,
    eJAT_HeadShake = 7,
};

// 自拍检测，返回值
enum enumCheckSelfPhotoType{
	eCSPT_OK				= 0,
	eCSPT_ParamError		= -1,	// 参数错误
	eCSPT_DTFailed			= -2,	// DT算法初始化错误
	eCSPT_FPGEFailed		= -3,	// FPGE算法初始化错误
	eCSPT_DTCfgFailed		= -4,	// DT算法配置参数错误
	eCSPT_DTDetectionFailed	= -5,	// DT算法检测人脸错误
	eCSPT_DetailedFailed	= -6,	// 获取人脸特征点信息错误


    eCSPT_Small				= 1,	// 人脸过小
    eCSPT_Pose				= 2,	// 人脸姿态不正确
    eCSPT_Biased			= 3,	// 人脸位置太偏
    eCSPT_MoreFace			= 4,	// 检测到多张人脸
	eCSPT_NoFace			= 5,	// 没有检测到人脸
	eCSPT_Positive			= 6,	// 眼睛不水平
	eCSPT_Dusky				= 7,	// 光线昏暗
	eCSPT_Sidelight			= 8,	// 阴阳脸
};

enum eActionType_External
{
	eAT_External_None = 0,
	eAT_External_EYE = 1<<0,
	eAT_External_MOUTH = 1<<1,
	eAT_External_HEAD_TOP = 1<<2,
	eAT_External_SHAKE = 1<<3,

	eAT_External_ALL = (eAT_External_EYE | eAT_External_MOUTH | eAT_External_HEAD_TOP | eAT_External_SHAKE),
};

enum eActionDifficulty_External
{
	eAD_External_Easy = 0,
	eAD_External_Normal,
	eAD_External_Hard,

	eAD_External_Max,
};

#ifdef __cplusplus
extern "C" {
#endif

	JY_FACE_API int JYInit();
	JY_FACE_API int JYUnInit();
    
    //将预览byte*帧传给so
    JY_FACE_API int putFeatureBuf(SInputGrayBufInfo* pInGrayInfo, SScrImgInfo* pInSrcImgInfo);
    //接收提示语
    JY_FACE_API int getHintMsg();
    //接收需要执行指令次数
    JY_FACE_API int getTargetOperationCount();
    //接收需要执行指令动作
    JY_FACE_API int getTargetOperationAction();
    //接收执行指令成功还是失败
    JY_FACE_API int iSOperationSuccess();
    //接收已完成总的成功次数
    JY_FACE_API int getTotalSuccessCount();
    //接收已完成总的失败次数
    JY_FACE_API int getTotalFailCount();
    //接收倒计时
    JY_FACE_API int getCountClockTime();
    //接收某个动作已完成次数
    JY_FACE_API int getDoneOperationCount();
    //接收某个动作完成幅度
    JY_FACE_API int getDoneOperationRange();
    //是否完成活体检测
    JY_FACE_API int iSFinishBodyCheck();
    
    JY_FACE_API int setActionFrameNum(int iFrame);
    
    //设置采集的最优人脸照片最大数量
    JY_FACE_API int setOFPhotoNum(int iNum);
    //得到采集到的最优人脸照片个数
    JY_FACE_API int getOFPhotoNum();
    //得到某个index的最优人脸照片对应的原始照片buffer的size
    //也就是SScrImgInfo结构中的iBufSize，然后上层可以new出相应的buffer，调用getSrcImgBuffer
    //iIndex>=0
    JY_FACE_API int getSrcImgBufferSize(int iIndex);
    //得到某个index的最优人脸buf，buf空间是由上层申请的
    //iIndex>=0
    JY_FACE_API int getSrcImgBuffer(int iIndex, unsigned char* pOutSrcImgBuf);
    //设置某个indexx的最优人脸照片，jpg照片buffer
    //iIndex>=0
    JY_FACE_API int setPhotoJpgBuffer(int iIndex, unsigned char* pInJpgBuffer, int iJpgBufSize);

    //检测自拍照上的人脸是否满足要求
    JY_FACE_API int checkSelfPhotoGrayBuffer(SInputGrayBufInfo* pInGrayInfo);
    //设置自拍照jpg图像buf
    JY_FACE_API int setSelfPhotoJpgBuffer(unsigned char* pInJpgBuffer, int iJpgBufSize);

    JY_FACE_API int openGifVideo(int bOpen);
    //得到gif动画帧数
    JY_FACE_API int getGifPhotoNum();
    //得到某个index的GIF动画帧对应的原始照片buffer的size
    //也就是SScrImgInfo结构中的iBufSize，然后上层可以new出相应的buffer，调用getGifSrcImgBuffer
    //iIndex>=0
    JY_FACE_API int getGifSrcImgBufferSize(int iIndex);
    //得到某个index的GIF动画帧对应的原始照片buf，buf空间是由上层申请的
    //iIndex>=0
    JY_FACE_API int getGifSrcImgBuffer(int iIndex, unsigned char* pOutSrcImgBuf);
    //设置某个index的Gif动画照片，jpg照片buffer
    //iIndex>=0
    JY_FACE_API int setGifImgJpgBuffer(int iIndex, unsigned char* pInJpgBuffer, int iJpgBufSize);

	//设置视频录像buf和使用的字符串,pText必须有\0结束符
	JY_FACE_API int putVideoBuf(unsigned char* pVideoBuf, int iBufSize, char* pText);

    //获取data buffer
    JY_FACE_API int getDataBufferSize();
    JY_FACE_API int getDataBuffer(unsigned char* pOutDataBuffer);

	//获取身份证翻拍照上人脸位置, 返回值enumCheckSelfPhotoType
	JY_FACE_API int getFacePos(SInputGrayBufInfo* pInGrayInfo, int* pLeft, int* pTop, int* pRight, int* pBottom);

	JY_FACE_API int getClarityScore(SInputGrayBufInfo* pInGrayInfo);
    
    //获取已替换的最优人脸个数
    JY_FACE_API int getOFFaceIndex_forTest(int* pScore);

	//版本信息(pTextInfo在50字节以内，是ASCII字符串)(成功返回0，不成功返回-1)
	JY_FACE_API int getVersion(int* p1, int* p2, int* p3, int* p4, unsigned char* pTextInfo, int iTextInfoSize);

	// 配置
	// iActionType	动作种类，参见eActionType_External，可以多选
	// iActionNum	动作次数，[1, 3]
	// iDifficulty	动作难易程度，参见eActionDifficulty_External
	JY_FACE_API int	setCfg(int iActionType, int iActionNum, int iDifficulty);


#ifdef __cplusplus
}
#endif//__cplusplus

#endif//_Included_FaceModuleHead_
