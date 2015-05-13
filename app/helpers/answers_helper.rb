require 'gsl'
require 'tf-idf-similarity'

module AnswersHelper
  def self.get_similarity(t1, t2)
    solution_doc = TfIdfSimilarity::Document.new(t1)
    answer_doc = TfIdfSimilarity::Document.new(t2)
    corpus = [solution_doc, answer_doc]
    model = TfIdfSimilarity::TfIdfModel.new(corpus, library: :gsl)
    matrix = model.similarity_matrix
    similarity = matrix[0, 1]
    return similarity
  end
end
