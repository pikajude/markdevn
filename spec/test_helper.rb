def wrap(txt)
  %Q{<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>
  #{txt}
</en-note>}
end
