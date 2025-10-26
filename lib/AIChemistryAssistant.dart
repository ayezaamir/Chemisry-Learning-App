import 'package:flutter/material.dart';
import 'dialogflow_service.dart';

class AIChemistryAssistant extends StatefulWidget {
  @override
  _AIChemistryAssistantState createState() => _AIChemistryAssistantState();
}

class _AIChemistryAssistantState extends State<AIChemistryAssistant> {
  List<Map<String, String>> messages = [];
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();

    setState(() {
      messages.add({"sender": "user", "message": userMessage});
      _controller.clear();
      _isLoading = true;
    });

    try {
      String aiResponse = await DialogflowService.getDialogflowResponse(userMessage);
      setState(() {
        messages.add({"sender": "ai", "message": aiResponse});
      });
    } catch (e) {
      setState(() {
        messages.add({"sender": "ai", "message": "Error fetching response: ${e.toString()}"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Chemistry Assistant",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]['sender'] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[index]['message']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask a chemistry question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
