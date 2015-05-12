# BNToast
Shows a toast message in rounded rectangle for given time duration.

# How to use
float w = 300, h = 40;

float cornerRadius = MIN(w,h)*0.125;

float borderWidth = 1;

float duartionSeconds = 5;
  
Label* lblTitle = Label::createWithSystemFont("Your message will be here", "Marker Felt", 20);

BNToast::showToast(lblTitle, Size(w, h), cornerRadius, borderWidth, duartionSeconds, this);
  
