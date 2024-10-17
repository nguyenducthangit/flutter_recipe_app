import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Danh sách các đơn đặt hàng giả lập
  List<Map<String, dynamic>> orders = [
    {
      "id": 1,
      "item": "Pizza",
      "status": "Delivered",
      "time": "2 hours ago",
      "details": "Pepperoni Pizza, Large size"
    },
    {
      "id": 2,
      "item": "Burger",
      "status": "In Progress",
      "time": "30 minutes ago",
      "details": "Double Cheeseburger, no pickles"
    },
    {
      "id": 3,
      "item": "Sushi",
      "status": "Delivered",
      "time": "1 day ago",
      "details": "Salmon Nigiri, 10 pieces"
    },
    {
      "id": 4,
      "item": "Sandwich",
      "status": "Preparing",
      "time": "5 minutes ago",
      "details": "Ham Sandwich with extra cheese"
    },
  ];

  // Hàm xóa đơn hàng khỏi danh sách thông báo
  void _deleteNotification(int id) {
    setState(() {
      orders.removeWhere((order) => order['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                orders.clear(); // Xóa tất cả thông báo
              });
            },
          ),
        ],
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                "No notifications available",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                // Đặt màu sắc cho trạng thái đơn hàng
                Color statusColor;
                switch (order['status']) {
                  case "Delivered":
                    statusColor = Colors.green;
                    break;
                  case "In Progress":
                    statusColor = Colors.orange;
                    break;
                  case "Preparing":
                    statusColor = Colors.blue;
                    break;
                  default:
                    statusColor = Colors.grey;
                }

                return Dismissible(
                  key: Key(order['id'].toString()),
                  onDismissed: (direction) {
                    _deleteNotification(order['id']); // Xóa thông báo khi vuốt
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Order ${order['item']} dismissed"),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      order['item'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    subtitle: Text(order['time']),
                    leading: Icon(Icons.fastfood, color: statusColor),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        _showOrderDetails(context, order);
                      },
                    ),
                    onTap: () {
                      _showOrderDetails(context,
                          order); // Hiển thị chi tiết đơn hàng khi nhấn
                    },
                  ),
                );
              },
            ),
    );
  }

  // Hàm hiển thị chi tiết đơn đặt hàng trong một hộp thoại
  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Item: ${order['item']}"),
              const SizedBox(height: 8),
              Text("Status: ${order['status']}"),
              const SizedBox(height: 8),
              Text("Details: ${order['details']}"),
              const SizedBox(height: 8),
              Text("Time: ${order['time']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
