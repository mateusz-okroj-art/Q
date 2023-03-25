#pragma once

#include <filesystem>

#include <QtCore/QFile>

namespace Q
{
class File
{
  public:
	File(const std::filesystem::path&& path);
	Q_DISABLE_COPY(File)
	File(File&& file);

protected:
	File();

  private:
	QFile _file;


};
} // namespace Q