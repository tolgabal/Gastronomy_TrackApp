class InfoMessageProvider {
  static String getInfoMessage(String message) {

    if(message == "hotpreinfo"){
      return "The products you see on this page belong to the hot presentation. The check mark to the right of the products represents that the product can be reused, and the cross represents that it cannot be used again.";
    }else{
      return "The products you see on this page belong to the $message. The check mark to the right of the products represents that the product can be reused, and the cross represents that it cannot be used again.";
    }
  }
}
