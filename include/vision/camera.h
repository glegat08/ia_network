#pragma once

#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>

class camera
{
public:
	explicit camera(int device_index);

	bool is_opened() const;
	bool read(cv::Mat& frame);

private:
	cv::VideoCapture m_capture;
};