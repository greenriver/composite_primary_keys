require 'abstract_unit'
require 'fixtures/product'
require 'fixtures/tariff'
require 'fixtures/product_tariff'

class AssociationTest < Test::Unit::TestCase
  fixtures :products, :tariffs, :product_tariffs

  def setup
    super
    @first_product = products(:first_product)
    @flat = tariffs(:flat)
    @free = tariffs(:free)
    @first_flat = product_tariffs(:first_flat)
  end
  
  def test_setup
    assert_not_nil @first_product
    assert_not_nil @flat
    assert_not_nil @free
    assert_not_nil @first_flat
  end
  
  def xtest_quoted_table_columns
    assert_equal "product_tariffs.product_id,product_tariffs.tariff_id,product_tariffs.tariff_start_date", 
        ProductTariff.send(:quoted_table_columns, ProductTariff.primary_key)
  end
  
  def xtest_count
    assert_equal 2, Product.count(:include => :product_tariffs)
    assert_equal 3, Tariff.count(:include => :product_tariffs)
  end
  
  def xtest_products
    assert_not_nil @first_product.product_tariffs
    assert_equal 2, @first_product.product_tariffs.length
    assert_not_nil @first_product.tariffs
    assert_equal 2, @first_product.tariffs.length
    assert_not_nil @first_product.product_tariff
  end
  
  def xtest_product_tariffs
    assert_not_nil @first_flat.product
    assert_not_nil @first_flat.tariff
    assert_equal Product, @first_flat.product.class
    assert_equal Tariff, @first_flat.tariff.class
  end
  
  def test_tariffs
    assert_not_nil @flat.product_tariffs
    assert_equal 1, @flat.product_tariffs.length
    assert_not_nil @flat.products
    assert_equal 2, @flat.products.length
    assert_not_nil @flat.product_tariff
  end
  
  def test_find_includes
    assert products = Product.find(:all, :include => :product_tariffs)
    assert_equal 2, @products.length
    assert tariffs = Tariff.find(:all, :include => :product_tariffs)
    assert_equal 3, @tariffs.length
  end
  
  #I'm also having problems when I use composite primary keys together with eager loading of associations. Here I'm doing
#ArtistName.find(:all, :include => :artist, ...)
# => ActiveRecord::StatementInvalid: Mysql::Error: Unknown column 'artists_names.artist_id,name' in 'field list': SELECT artists_names.`artist_id,name` AS t0_r0, ....
# Had a brief look into it but couldn't spot the code causing this...
end