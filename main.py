
from pipeline_relational_data.flow import RelationalDataFlow
from Pipeline_dimensional_data.flow import DimensionalDataFlow


if __name__ == '__main__':
    # Create an instance of RelationalDataFlow
    relational_flow = RelationalDataFlow()
    # Execute relational data tasks
    relational_flow.exec()

    # Create an instance of DimensionalDataFlow
    dimensional_flow = DimensionalDataFlow()
    # Execute dimensional data tasks
    dimensional_flow.exec()
