#include "MinimalPublisher.h"

using namespace std::chrono_literals;

/* 
  This example creates a subclass of Node and uses std::bind() to register a
  member function as a callback from the timer. 
*/

class MinimalPublisher : public rclcpp::Node { // MinimalPublisher extends rclcpp Node class
public:
  MinimalPublisher() : Node("minimal_publisher"), count_(0) { // names node "minimal_publisher" and creates a 
                                                              // member variable count_ that starts at 0
    publisher = this->create_publisher<std_msgs::msg::String>("topic", 10);
    timer_ = this->create_wall_timer(500ms, std::bind(&MinimalPublisher::timer_callback, this)); // timer_()
  }

private:
  void timer_callback() {
    auto message = std_msgs::msg:String(); // string message
    message.data = "Hello, World! " + std::to_string(count_++); // ros2 has a string class with (SharedPtr) and (data)
    RCLCPP_INFO(this->get_logger(), "Publishing: '%s'", message.data.c_str()); // convert to c-style string bc
                                                                               // INFO logger needs it
  }

  rclcpp::TimerBase::SharedPtr timer_; // member var called timer which is a ptr
  rclcpp::Publisher<std_msgs::msg::String>::SharedPtr publisher_; // create Publisher with type support and is a ptr
  size_t count_; // declare count_
}

int main(int argc, char* argv[]) {
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<MinimalPublisher>()); // shared ptr deletes itself when done used
                                                      // spin until ctrl+C
  rclcpp::shutdown();
  return 0;
}