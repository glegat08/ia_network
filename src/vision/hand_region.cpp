#include "vision/hand_region.h"

#include <opencv2/imgproc.hpp>

hand_region::hand_region(int size, int margin)
	: m_size(size)
	, m_margin(margin)
{
}

cv::Rect hand_region::area(const cv::Mat& frame) const
{
	return cv::Rect(frame.cols - m_size - m_margin, m_margin, m_size, m_size);
}

void hand_region::draw(cv::Mat& frame) const
{
	cv::rectangle(frame, area(frame), cv::Scalar(0, 255, 0), 2);
}