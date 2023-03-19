#pragma once

#include <fstream>

#include <QCoreBSONExport.h>

namespace Q
{
	namespace Core
	{
		#define ClassName BSONDocument

		class Q_CORE_BSON_EXPORT ClassName
		{
		public:
			BSONDocument();

			static ClassName loadFromFile(const std::ifstream& file);

		private:
			BSONDocument(const void* data, size_t length);
		};
	}
}