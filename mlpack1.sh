# Get the dataset and unpack it.
wget https://www.mlpack.org/datasets/covertype-small.data.csv.gz
wget https://www.mlpack.org/datasets/covertype-small.labels.csv.gz
gunzip covertype-small.data.csv.gz covertype-small.labels.csv.gz
# Split the dataset; 70% into a training set and 30% into a test set.
# Each of these options has a shorthand single-character option but here we type
# it all out for clarity.
mlpack_preprocess_split                                       \
    --input_file covertype-small.data.csv                     \
    --input_labels_file covertype-small.labels.csv            \
    --training_file covertype-small.train.csv                 \
    --training_labels_file covertype-small.train.labels.csv   \
    --test_file covertype-small.test.csv                      \
    --test_labels_file covertype-small.test.labels.csv        \
    --test_ratio 0.3                                          \
    --verbose
# Train a random forest.
mlpack_random_forest                                  \
    --training_file covertype-small.train.csv         \
    --labels_file covertype-small.train.labels.csv    \
    --num_trees 10                                    \
    --minimum_leaf_size 3                             \
    --print_training_accuracy                         \
    --output_model_file rf-model.bin                  \
    --verbose
# Now predict the labels of the test points and print the accuracy.
# Also, save the test set predictions to the file 'predictions.csv'.
mlpack_random_forest                                    \
    --input_model_file rf-model.bin                     \
    --test_file covertype-small.test.csv                \
    --test_labels_file covertype-small.test.labels.csv  \
    --predictions_file predictions.csv                  \
    --verbose
