CREATE TABLE `globals` (`key` TEXT PRIMARY KEY, `value` TEXT);
INSERT INTO `globals` (`key`, `value`) VALUES ('version', '1');

CREATE TABLE `bundle` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`path` TEXT NOT NULL,
	`bundle_id` TEXT NOT NULL,
	`checksum` INTEGER NOT NULL,
	'package_type' TEXT,
	'creator' TEXT,
	'signature' TEXT
);
CREATE INDEX `bundle_id_index` ON `bundle`(`bundle_id`);
CREATE INDEX `bundle_path_index` ON `bundle`(`path`);
CREATE INDEX `bundle_type` ON `bundle`(`package_type`);
CREATE INDEX `bundle_creator` ON `bundle`(`creator`);
CREATE INDEX `bundle_signature` ON `bundle`(`signature`);

CREATE TABLE `uti` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`type_identifier` TEXT NOT NULL COLLATE NOCASE, -- UTTypeIdentifier
	`description` TEXT, -- UTTypeDescription
	`bundle` INTEGER,
	FOREIGN KEY(`bundle`) REFERENCES `bundle`(`id`) ON DELETE CASCADE
);
CREATE INDEX `uti_ident_index` ON `uti`(`type_identifier`);
CREATE INDEX `uti_bundle_index` ON `uti`(`bundle`);

-- UTTypeConformsTo
CREATE TABLE `uti_conforms` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`uti` INTEGER,
	`conforms_to` TEXT NOT NULL COLLATE NOCASE,
	FOREIGN KEY(`uti`) REFERENCES `uti`(`id`) ON DELETE CASCADE
);
CREATE INDEX `uti_conforms_index` ON `uti_conforms`(`conforms_to`);
CREATE INDEX `uti_conforms_uti_index` ON `uti_conforms`(`uti`);

-- UTTypeIconFiles
CREATE TABLE `uti_icon` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`uti` INTEGER,
	`file` TEXT NOT NULL,
	FOREIGN KEY(`uti`) REFERENCES `uti`(`id`) ON DELETE CASCADE
);
CREATE INDEX `uti_icon_uti_index` ON `uti_icon`(`uti`);

-- UTTypeTagSpecification
CREATE TABLE `uti_tag` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`uti` INTEGER,
	`tag` TEXT NOT NULL,
	`value` TEXT NOT NULL COLLATE NOCASE,
	FOREIGN KEY(`uti`) REFERENCES `uti`(`id`) ON DELETE CASCADE
);
CREATE INDEX `uti_tag_uti_index` ON `uti_tag`(`uti`);
CREATE INDEX `uti_tag_index1` ON `uti_tag`(`tag`);
CREATE INDEX `uti_tag_index2` ON `uti_tag`(`tag`, `value`);

-- https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundledocumenttypes?language=objc

CREATE TABLE `app_doc` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`bundle` INTEGER,
	`icon` TEXT, -- CFBundleTypeIconFile
	`name` TEXT, -- CFBundleTypeName
	`role` TEXT, -- CFBundleTypeRole
	`rank` TEXT, -- LSHandlerRank
	`class` TEXT, -- NSDocumentClass
	FOREIGN KEY(`bundle`) REFERENCES `bundle`(`id`) ON DELETE CASCADE
);
CREATE INDEX `app_doc_bundle_index` ON `app_doc`(`bundle`);

-- LSItemContentTypes
CREATE TABLE `app_doc_uti` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`doc` INTEGER,
	`uti` TEXT,
	FOREIGN KEY(`doc`) REFERENCES `app_doc`(`id`) ON DELETE CASCADE
);
CREATE INDEX `app_doc_uti_doc_index` ON `app_doc_uti`(`doc`);
CREATE INDEX `app_doc_uti_index` ON `app_doc_uti`(`uti`);

-- obsolete CFBundleTypeMIMETypes
CREATE TABLE `app_doc_mime` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`doc` INTEGER,
	`mime` TEXT,
	FOREIGN KEY(`doc`) REFERENCES `app_doc`(`id`) ON DELETE CASCADE
);
CREATE INDEX `app_doc_mime_doc_index` ON `app_doc_mime`(`doc`);
CREATE INDEX `app_doc_mime_index` ON `app_doc_mime`(`mime`);

-- obsolete CFBundleTypeExtensions
CREATE TABLE `app_doc_extension` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`doc` INTEGER,
	`extension` TEXT,
	FOREIGN KEY(`doc`) REFERENCES `app_doc`(`id`) ON DELETE CASCADE
);
CREATE INDEX `app_doc_extension_doc_index` ON `app_doc_extension`(`doc`);
CREATE INDEX `app_doc_extension_index` ON `app_doc_extension`(`extension`);
