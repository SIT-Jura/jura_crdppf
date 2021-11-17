CREATE SCHEMA IF NOT EXISTS pyramid_oereb_main;

CREATE TABLE pyramid_oereb_main.address (
	street_name VARCHAR NOT NULL, 
	street_number VARCHAR NOT NULL, 
	zip_code INTEGER NOT NULL, 
	geom geometry(POINT,2056), 
	PRIMARY KEY (street_name, street_number, zip_code)
)

;

CREATE TABLE pyramid_oereb_main.disclaimer (
	id VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	content JSON NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.document_types (
	code VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	PRIMARY KEY (code)
)

;

CREATE TABLE pyramid_oereb_main.general_information (
	id VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	content JSON NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.glossary (
	id VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	content JSON NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.law_status (
	code VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	PRIMARY KEY (code)
)

;

CREATE TABLE pyramid_oereb_main.logo (
	id VARCHAR NOT NULL, 
	code VARCHAR NOT NULL, 
	logo JSON NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.map_layering (
	id VARCHAR NOT NULL, 
	view_service JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.municipality (
	fosnr INTEGER NOT NULL, 
	name VARCHAR NOT NULL, 
	published BOOLEAN DEFAULT FALSE NOT NULL, 
	geom geometry(MULTIPOLYGON,2056), 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE pyramid_oereb_main.office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.real_estate (
	id SERIAL NOT NULL, 
	identdn VARCHAR, 
	number VARCHAR, 
	egrid VARCHAR, 
	type VARCHAR NOT NULL, 
	canton VARCHAR NOT NULL, 
	municipality VARCHAR NOT NULL, 
	subunit_of_land_register VARCHAR, 
	subunit_of_land_register_designation VARCHAR, 
	fosnr INTEGER NOT NULL, 
	metadata_of_geographical_base_data VARCHAR, 
	land_registry_area INTEGER NOT NULL, 
	"limit" geometry(MULTIPOLYGON,2056), 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.real_estate_type (
	id VARCHAR NOT NULL, 
	code VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE pyramid_oereb_main.theme (
	id VARCHAR NOT NULL, 
	code VARCHAR NOT NULL, 
	sub_code VARCHAR, 
	title JSON NOT NULL, 
	extract_index INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (code, sub_code)
)

;

CREATE TABLE pyramid_oereb_main.document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES pyramid_oereb_main.office (id)
)

;

CREATE TABLE pyramid_oereb_main.theme_document (
	theme_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	article_numbers JSON, 
	PRIMARY KEY (theme_id, document_id), 
	FOREIGN KEY(theme_id) REFERENCES pyramid_oereb_main.theme (id), 
	FOREIGN KEY(document_id) REFERENCES pyramid_oereb_main.document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(GEOMETRYCOLLECTION,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(POLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(MULTIPOLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(LINESTRING,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(POLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(LINESTRING,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(POLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(LINESTRING,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(MULTIPOLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(GEOMETRYCOLLECTION,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(GEOMETRYCOLLECTION,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(GEOMETRYCOLLECTION,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(GEOMETRYCOLLECTION,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(POLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(POLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(POLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(LINESTRING,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(LINESTRING,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(LINESTRING,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
CREATE SCHEMA IF NOT EXISTS None;

CREATE TABLE availability (
	fosnr VARCHAR NOT NULL, 
	available BOOLEAN NOT NULL, 
	PRIMARY KEY (fosnr)
)

;

CREATE TABLE office (
	id VARCHAR NOT NULL, 
	name JSON NOT NULL, 
	office_at_web JSON, 
	uid VARCHAR(12), 
	line1 VARCHAR, 
	line2 VARCHAR, 
	street VARCHAR, 
	number VARCHAR, 
	postal_code INTEGER, 
	city VARCHAR, 
	PRIMARY KEY (id)
)

;

CREATE TABLE view_service (
	id VARCHAR NOT NULL, 
	reference_wms JSON NOT NULL, 
	layer_index INTEGER NOT NULL, 
	layer_opacity FLOAT NOT NULL, 
	PRIMARY KEY (id)
)

;

CREATE TABLE data_integration (
	id VARCHAR NOT NULL, 
	date TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	office_id VARCHAR NOT NULL, 
	checksum VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE document (
	id VARCHAR NOT NULL, 
	document_type VARCHAR NOT NULL, 
	index INTEGER NOT NULL, 
	law_status VARCHAR NOT NULL, 
	title JSON NOT NULL, 
	office_id VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	text_at_web JSON, 
	abbreviation JSON, 
	official_number JSON, 
	only_in_municipality INTEGER, 
	file VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(office_id) REFERENCES office (id)
)

;

CREATE TABLE legend_entry (
	id VARCHAR NOT NULL, 
	symbol VARCHAR NOT NULL, 
	legend_text JSON NOT NULL, 
	type_code VARCHAR(40) NOT NULL, 
	type_code_list VARCHAR NOT NULL, 
	theme VARCHAR NOT NULL, 
	sub_theme VARCHAR, 
	view_service_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id)
)

;

CREATE TABLE public_law_restriction (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	view_service_id VARCHAR NOT NULL, 
	office_id VARCHAR NOT NULL, 
	legend_entry_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(view_service_id) REFERENCES view_service (id), 
	FOREIGN KEY(office_id) REFERENCES office (id), 
	FOREIGN KEY(legend_entry_id) REFERENCES legend_entry (id)
)

;

CREATE TABLE geometry (
	id VARCHAR NOT NULL, 
	law_status VARCHAR NOT NULL, 
	published_from DATE NOT NULL, 
	published_until DATE, 
	geo_metadata VARCHAR, 
	geom geometry(POLYGON,2056) NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id)
)

;

CREATE TABLE public_law_restriction_document (
	id VARCHAR NOT NULL, 
	public_law_restriction_id VARCHAR NOT NULL, 
	document_id VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(public_law_restriction_id) REFERENCES public_law_restriction (id), 
	FOREIGN KEY(document_id) REFERENCES document (id)
)

;
