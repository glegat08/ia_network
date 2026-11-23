#include "vision/camera.h"

#include <opencv2/core.hpp>

camera::camera(int device_index)
	: m_capture(device_index)
{
}

bool camera::is_opened() const
{
	return m_capture.isOpened();
}

bool camera::read(cv::Mat& frame)
{
	m_capture.read(frame);

	if (frame.empty())
		return false;

	cv::flip(frame, frame, 1);

	return true;
}
