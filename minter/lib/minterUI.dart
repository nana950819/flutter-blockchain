import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minter/contract_linking.dart';
import 'package:provider/provider.dart';

class MinterUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Minter"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        height: 350,
                        child: Image(
                          image: NetworkImage(
                              "https://goldrushgolf.com.au/wp-content/uploads/Gold-Miner3.png"),
                        ),
                      ),
                      Text(
                        "Minter is ${contractLink.minterAddress.substring(0, 11)}XXXX",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: 350,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent.withOpacity(0.9)),
                            icon: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.black,
                            ),
                            label: Text("Check Balance"),
                            onPressed: () {
                              balanceDialog(context);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: 350,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent.withOpacity(0.9)),
                            icon: Icon(
                              Icons.money,
                              color: Colors.black,
                            ),
                            label: Text("Mint Coins"),
                            onPressed: () {
                              mintCoinDialog(context);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: 350,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent.withOpacity(0.9)),
                            icon: Icon(
                              Icons.offline_share,
                              color: Colors.black,
                            ),
                            label: Text("Send Coins"),
                            onPressed: () {
                              sendCoinDialog(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  balanceDialog(context) {
    var contractLink = Provider.of<ContractLinking>(context, listen: false);
    TextEditingController accountAddr = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Check Balance",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: TextField(
                    controller: accountAddr,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Account Address",
                        hintText: "Enter Your Account Address..."),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            String balance =
                                await contractLink.getBalance(accountAddr.text);
                            print(balance);
                            showToast(
                                "${accountAddr.text.substring(0, 5)}XXXX has $balance Coins.",
                                context);
                            //Navigator.pop(context);
                          },
                          child: Text("Balance")),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  mintCoinDialog(context) {
    var contractLink = Provider.of<ContractLinking>(context, listen: false);
    TextEditingController accountAddr = TextEditingController();
    TextEditingController coinsAmount = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Mint Coins",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 8.0),
                  child: TextField(
                    controller: accountAddr,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Account Address",
                        hintText: "Enter Account Address..."),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: coinsAmount,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Coins Amount",
                        hintText: "Enter Coins Amount To Mint..."),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            contractLink.mintCoins(
                                accountAddr.text, int.parse(coinsAmount.text));
                            showToast(
                                "Coins ${coinsAmount.text} minted to ${accountAddr.text.substring(0, 5)}XXXX",
                                context);
                            Navigator.pop(context);
                          },
                          child: Text("Mint")),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  sendCoinDialog(context) {
    var contractLink = Provider.of<ContractLinking>(context, listen: false);
    TextEditingController senderAddr = TextEditingController();
    TextEditingController receiverAddr = TextEditingController();
    TextEditingController coinsAmount = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Send Coins",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 8.0),
                  child: TextField(
                    controller: senderAddr,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Sender Account Addr...",
                        hintText: "Enter Sender Account Address..."),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: receiverAddr,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Receiver Account Addr...",
                        hintText: "Enter Receiver Account Address..."),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: coinsAmount,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Coins To Transfer",
                        hintText: "Enter Coins Amount To Send..."),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            contractLink.sendCoins(senderAddr.text,
                                receiverAddr.text, int.parse(coinsAmount.text));
                            showToast(
                                "Transferred ${coinsAmount.text} from ${senderAddr.text.substring(0, 5)}XXXX to ${receiverAddr.text.substring(0, 5)}XXXX",
                                context);
                            Navigator.pop(context);
                          },
                          child: Text("Send")),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Theme.of(context).accentColor,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      textColor: Colors.black,
      fontSize: 20,
    );
  }
}
