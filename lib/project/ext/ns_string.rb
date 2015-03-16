# Shamelessly extracted from sugarcube
# https://github.com/rubymotion/sugarcube/blob/master/lib/cocoa/sugarcube-files/nsstring.rb
class NSString

  def document_path
    @@motionconcierge_docs ||= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
    return self if self.hasPrefix(@@motionconcierge_docs)

    @@motionconcierge_docs.stringByAppendingPathComponent(self)
  end

  def resource_path
    @@motionconcierge_resources ||= NSBundle.mainBundle.resourcePath
    return self if self.hasPrefix(@@motionconcierge_resources)

    @@motionconcierge_resources.stringByAppendingPathComponent(self)
  end

  def file_exists?
    path = self.hasPrefix('/') ? self : self.document_path
    NSFileManager.defaultManager.fileExistsAtPath(path)
  end

  def remove_file!
    ptr = Pointer.new(:id)
    path = self.hasPrefix('/') ? self : self.document_path
    NSFileManager.defaultManager.removeItemAtPath(path, error:ptr)
    ptr[0]
  end

  def resource_exists?
    self.resource_path.file_exists?
  end

end
