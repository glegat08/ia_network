#pragma once

#include <opencv2/core.hpp>

class hand_region
{
public:
	hand_region(int size, int margin);

	cv::Rect area(const cv::Mat& frame) const;
	void draw(cv::Mat& frame) const;

private:
	int m_size;
	int m_margin;
};