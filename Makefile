#################### PACKAGE ACTIONS ###################

reinstall_package:
	@pip uninstall -y chords-prog-proj || :
	@pip install -e .

run_preprocess:
	python -c 'from chords_prog_proj.interface.main import preprocess; preprocess(); preprocess(source_type="val")'

run_train:
	python -c 'from chords_prog_proj.interface.main import train; train()'

run_pred:
	python -c 'from chords_prog_proj.interface.main import pred; pred()'

run_evaluate:
	python -c 'from chords_prog_proj.interface.main import evaluate; evaluate()'

run_all: run_preprocess run_train run_pred run_evaluate

# legacy directive
run_model: run_all

run_workflow:
	PREFECT__LOGGING__LEVEL=${PREFECT_LOG_LEVEL} python -m chords_prog_proj.flow.main

run_api:
	uvicorn chords_prog_proj.api.fast:app --reload

##################### TESTS #####################
default:
	@echo 'tests are only executed locally for this challenge'

test_cloud_training: test_gcp_setup test_gcp_project test_gcp_bucket test_big_query test_cloud_data

test_gcp_setup:
	@TEST_ENV=development pytest \
	tests/setup/test_gcp_setup.py::TestGcpSetup::test_setup_key_env \
	tests/setup/test_gcp_setup.py::TestGcpSetup::test_setup_key_path \
	tests/setup/test_gcp_setup.py::TestGcpSetup::test_code_get_project

test_gcp_project:
	@TEST_ENV=development pytest \
	tests/setup/test_gcp_setup.py::TestGcpSetup::test_setup_project_id

test_gcp_bucket:
	@TEST_ENV=development pytest \
	tests/setup/test_gcp_setup.py::TestGcpSetup::test_setup_bucket_exists \
	tests/setup/test_gcp_setup.py::TestGcpSetup::test_setup_bucket_name

test_big_query:
	@TEST_ENV=development pytest \
	tests/cloud_data/test_cloud_data.py::TestCloudData::test_big_query_dataset_variable_exists \
	tests/cloud_data/test_cloud_data.py::TestCloudData::test_cloud_data_create_dataset \
	tests/cloud_data/test_cloud_data.py::TestCloudData::test_cloud_data_create_table \
	tests/cloud_data/test_cloud_data.py::TestCloudData::test_cloud_data_table_content

test_cloud_data:
	@TEST_ENV=development pytest tests/cloud_data/test_cloud_data.py::TestCloudData::test_cloud_data_bq_chunks

test_api: test_api_root test_api_predict

test_api_root:
	TEST_ENV=development pytest tests/api -k 'test_root' --asyncio-mode=strict -W "ignore"

test_api_predict:
	TEST_ENV=development pytest tests/api -k 'test_predict' --asyncio-mode=strict -W "ignore"


##################### DEBUGGING HELPERS ####################
fbold=$(shell echo "\033[1m")
fnormal=$(shell echo "\033[0m")
ccgreen=$(shell echo "\033[0;32m")
ccblue=$(shell echo "\033[0;34m")
ccreset=$(shell echo "\033[0;39m")

show_env:
	@echo "\nEnvironment variables used by the \`chords-prog-proj\` package loaded by \`direnv\` from your \`.env\` located at:"
	@echo ${DIRENV_DIR}

	@echo "\n$(ccgreen)local storage:$(ccreset)"
	@env | grep -E "LOCAL_DATA_PATH|LOCAL_REGISTRY_PATH" || :
	@echo "\n$(ccgreen)dataset:$(ccreset)"
	@env | grep -E "DATASET_SIZE|VALIDATION_DATASET_SIZE|CHUNK_SIZE" || :
	@echo "\n$(ccgreen)package behavior:$(ccreset)"
	@env | grep -E "DATA_SOURCE|MODEL_TARGET" || :

	@echo "\n$(ccgreen)GCP:$(ccreset)"
	@env | grep -E "PROJECT|REGION" || :

	@echo "\n$(ccgreen)Big Query:$(ccreset)"
	@env | grep -E "DATASET" | grep -Ev "DATASET_SIZE|VALIDATION_DATASET_SIZE" || :\

	@echo "\n$(ccgreen)Compute Engine:$(ccreset)"
	@env | grep -E "INSTANCE" || :

	@echo "\n$(ccgreen)MLflow:$(ccreset)"
	@env | grep -E "MLFLOW_EXPERIMENT|MLFLOW_MODEL_NAME" || :
	@env | grep -E "MLFLOW_TRACKING_URI|MLFLOW_TRACKING_DB" || :

	@echo "\n$(ccgreen)Prefect:$(ccreset)"
	@env | grep -E "PREFECT_BACKEND|PREFECT_FLOW_NAME|PREFECT_LOG_LEVEL" || :

list:
	@echo "\nHelp for the \`chords-prog-api\` package \`Makefile\`"

	@echo "\n$(ccgreen)$(fbold)PACKAGE$(ccreset)"

	@echo "\n    $(ccgreen)$(fbold)environment rules:$(ccreset)"
	@echo "\n        $(fbold)show_env$(ccreset)"
	@echo "            Show the environment variables used by the package by category."

	@echo "\n    $(ccgreen)$(fbold)run rules:$(ccreset)"
	@echo "\n        $(fbold)run_all$(ccreset)"
	@echo "            Run the package (\`chords_prog_proj.interface.main\` module)."

	@echo "\n        $(fbold)run_workflow$(ccreset)"
	@echo "            Start a prefect workflow locally (run the \`chords_prog_proj.flow.main\` module)."

	@echo "\n$(ccgreen)$(fbold)WORKFLOW$(ccreset)"

	@echo "\n    $(ccgreen)$(fbold)data operation rules:$(ccreset)"
	@echo "\n        $(fbold)show_sources_all$(ccreset)"
	@echo "            Show all data sources."
	@echo "\n        $(fbold)show_sources_env$(ccreset)"
	@echo "            Show ${DATASET_SIZE} data sources."
	@echo "\n        $(fbold)reset_sources_all$(ccreset)"
	@echo "            Reset all data sources."
	@echo "\n        $(fbold)reset_sources_env$(ccreset)"
	@echo "            Reset ${DATASET_SIZE} data sources."
	@echo "\n        $(fbold)delete_new_source$(ccreset)"
	@echo "            Delete monthly data source."

	@echo "\n$(ccgreen)$(fbold)TESTS$(ccreset)"

	@echo "\n    $(ccgreen)$(fbold)student rules:$(ccreset)"
	@echo "\n        $(fbold)reinstall_package$(ccreset)"
	@echo "            Install the version of the package corresponding to the challenge."
	@echo "\n        $(fbold)test_cloud_training$(ccreset)"
	@echo "            Run the tests."
