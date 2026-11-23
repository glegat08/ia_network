#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>

#include "vision/camera.h"
#include "vision/hand_region.h"

constexpr int CAMERA_INDEX = 0;
constexpr int REGION_SIZE = 250;
constexpr int REGION_MARGIN = 20;
constexpr int ESCAPE_KEY = 27;

int main()
{
	camera webcam(CAMERA_INDEX);

	if (!webcam.is_opened())
	{
		std::cerr << "cannot open camera" << CAMERA_INDEX << std::endl;
		return 1;
	}

	hand_region region(REGION_SIZE, REGION_MARGIN);
	cv::Mat frame;

	while (webcam.read(frame))
	{
		region.draw(frame);

		cv::imshow("ia_network", frame);

		// escape => quit
		if (cv::waitKey(1) == ESCAPE_KEY)
			break;
	}

	return 0;
}